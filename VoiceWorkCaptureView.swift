import SwiftUI

@available(iOS 26.0, * //iPhone 15 pro - iPhone 18 pro, iPhone 17, iPhone 16e~iPhone 17e, iPhone Duo)
struct VoiceWorkCaptureView: View {

    @EnvironmentObject var appStore: AppStore
    @Environment(\.dismiss) private var dismiss

    @StateObject private var speechService = SpeechService()
    @StateObject private var summaryService = WorkSummaryService()

    @State private var taskTitle = "현장 업무 기록"

    private var isRecording: Bool {
        speechService.isRecording
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Header

                    VStack(alignment: .leading, spacing: 8) {

                        Text("WORKMATE AI")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(1.5)
                            .foregroundStyle(AppTheme.Colors.accent)

                        Text("음성 업무 기록")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("말로 기록하고 AI로 업무일지를 정리하세요.")
                            .foregroundStyle(.secondary)
                    }

                    // MARK: - Recording

                    VStack(spacing: 18) {

                        Image(systemName: isRecording
                              ? "waveform"
                              : "mic.fill")
                            .font(.system(size: 42))
                            .foregroundStyle(
                                isRecording ? .red : AppTheme.Colors.accent
                            )
                            .frame(width: 100, height: 100)
                            .background(
                                AppTheme.Colors.secondaryBackground
                            )
                            .clipShape(Circle())

                        Text(
                            isRecording
                            ? "음성을 듣고 있습니다"
                            : "업무 내용을 말해 보세요"
                        )
                        .font(.headline)

                        Button {

                            if isRecording {

                                speechService.stopRecording()

                            } else {

                                Task {
                                    await speechService.startRecording()
                                }
                            }

                        } label: {

                            Label(
                                isRecording ? "녹음 종료" : "녹음 시작",
                                systemImage: isRecording ? "stop.fill" : "mic.fill"
                            )
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                isRecording ? Color.red : AppTheme.Colors.accent
                            )
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(AppTheme.Colors.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 22))

                    // MARK: - Recognized Text

                    VStack(alignment: .leading, spacing: 12) {

                        HStack {

                            Text("음성 인식 결과")
                                .font(.headline)

                            Spacer()

                            Button("지우기") {
                                speechService.clearText()
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        Text(
                            speechService.recognizedText.isEmpty
                            ? "아직 기록된 내용이 없습니다."
                            : speechService.recognizedText
                        )
                        .foregroundStyle(
                            speechService.recognizedText.isEmpty
                            ? .secondary : .primary
                        )
                        .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
                        .padding()
                        .background(AppTheme.Colors.secondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    // MARK: - AI Summary

                    Button {

                        Task {
                            await summaryService.createSummary(
                                from: speechService.recognizedText
                            )
                        }

                    } label: {

                        HStack {

                            if summaryService.isProcessing {

                                ProgressView()
                                    .tint(.white)

                                Text("AI가 정리하고 있습니다")

                            } else {

                                Image(systemName: "sparkles")

                                Text("AI 업무일지 생성")
                            }
                        }
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(
                        speechService.recognizedText
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .isEmpty ||
                        summaryService.isProcessing ||
                        isRecording
                    )

                    // MARK: - Summary Result

                    if !summaryService.summary.isEmpty {

                        VStack(alignment: .leading, spacing: 14) {

                            Label(
                                "AI 업무일지",
                                systemImage: "doc.text"
                            )
                            .font(.headline)

                            TextField(
                                "업무 제목",
                                text: $taskTitle
                            )
                            .textFieldStyle(.roundedBorder)

                            Text(summaryService.summary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(
                                    AppTheme.Colors.secondaryBackground
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 14))

                            Button {

                                saveSummary()

                            } label: {

                                Label(
                                    "업무 목록에 저장",
                                    systemImage: "square.and.arrow.down"
                                )
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.green)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }

                    // MARK: - Error

                    if let error = speechService.errorMessage
                        ?? summaryService.errorMessage {

                        Text(error)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
                .padding()
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("음성 기록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button("닫기") {
                        speechService.stopRecording()
                        dismiss()
                    }
                }
            }
        }
        .onDisappear {
            speechService.stopRecording()
        }
    }

    // MARK: - Save Summary

    private func saveSummary() {

        let title = taskTitle.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !title.isEmpty else { return }

        let newTask = WMTask(
            title: title,
            detail: summaryService.summary,
            scheduledAt: Date(),
            category: "일반"
        )

        appStore.addTask(newTask)

        dismiss()
    }
}
