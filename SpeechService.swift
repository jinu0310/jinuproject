import Foundation
import Speech
import AVFoundation

@MainActor
final class SpeechService: NSObject, ObservableObject {

    @Published var recognizedText = ""
    @Published var isRecording = false
    @Published var errorMessage: String?

    private let audioEngine = AVAudioEngine()

    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    override init() {
        super.init()
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
    }

    // MARK: - Permission

    func requestPermissions() async -> Bool {

        let speechStatus = await withCheckedContinuation {
            (continuation: CheckedContinuation<SFSpeechRecognizerAuthorizationStatus, Never>) in

            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }

        guard speechStatus == .authorized else {
            errorMessage = "음성 인식 권한이 필요합니다."
            return false
        }

        let audioSession = AVAudioApplication.shared

        let microphoneGranted = await audioSession.recordPermission == .granted

        guard microphoneGranted else {
            errorMessage = "마이크 권한을 확인해 주세요."
            return false
        }

        return true
    }

    // MARK: - Start Recording

    func startRecording() async {

        guard !isRecording else { return }

        let permissionGranted = await requestPermissions()

        guard permissionGranted else { return }

        guard let speechRecognizer,
              speechRecognizer.isAvailable else {

            errorMessage = "현재 음성 인식 서비스를 사용할 수 없습니다."
            return
        }

        do {

            try startAudioRecognition()

        } catch {

            errorMessage = error.localizedDescription
            stopRecording()
        }
    }

    private func startAudioRecognition() throws {

        recognitionTask?.cancel()
        recognitionTask = nil

        let audioSession = AVAudioSession.sharedInstance()

        try audioSession.setCategory(
            .record,
            mode: .measurement,
            options: [.duckOthers]
        )

        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let recognitionRequest else { return }

        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode

        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.removeTap(onBus: 0)

        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: recordingFormat
        ) { buffer, _ in

            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()

        try audioEngine.start()

        isRecording = true
        errorMessage = nil

        recognitionTask = speechRecognizer?.recognitionTask(
            with: recognitionRequest
        ) { [weak self] result, error in

            Task { @MainActor in

                if let result {

                    self?.recognizedText = result.bestTranscription.formattedString
                }

                if let error {

                    self?.errorMessage = error.localizedDescription
                    self?.stopRecording()
                }
            }
        }
    }

    // MARK: - Stop Recording

    func stopRecording() {

        guard isRecording else { return }

        audioEngine.stop()

        audioEngine.inputNode.removeTap(onBus: 0)

        recognitionRequest?.endAudio()

        recognitionTask?.finish()

        recognitionRequest = nil
        recognitionTask = nil

        isRecording = false

        try? AVAudioSession.sharedInstance().setActive(
            false,
            options: .notifyOthersOnDeactivation
        )
    }

    // MARK: - Clear Text

    func clearText() {

        recognizedText = ""
        errorMessage = nil
    }
}
