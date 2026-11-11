import Foundation
import Combine

@MainActor
final class WorkSummaryService: ObservableObject {

    @Published var isProcessing = false
    @Published var summary = ""
    @Published var errorMessage: String?

    @available(iOS 26.0, *)
    private let aiService = OnDeviceAIService()

    // MARK: - Create Summary

    @available(iOS 26.0, *)
    func createSummary(
        from voiceText: String
    ) async {

        let cleanedText = voiceText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedText.isEmpty else {

            errorMessage = "정리할 업무 내용을 입력해 주세요."
            return
        }

        isProcessing = true
        errorMessage = nil
        summary = ""

        defer {
            isProcessing = false
        }

        guard aiService.isAvailable else {

            errorMessage = "이 기기에서 온디바이스 AI를 사용할 수 없습니다."
            return
        }

        if let result = await aiService.summarizeWork(
            text: cleanedText
        ) {

            summary = result

        } else {

            errorMessage = aiService.errorMessage ?? "업무 요약에 실패했습니다."
        }
    }

    // MARK: - Improve Memo

    @available(iOS 26.0, *)
    func improveMemo(
        text: String
    ) async -> String? {

        let cleanedText = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedText.isEmpty else {

            errorMessage = "정리할 메모를 입력해 주세요."
            return nil
        }

        isProcessing = true
        errorMessage = nil

        defer {
            isProcessing = false
        }

        return await aiService.improveWorkMemo(
            text: cleanedText
        )
    }

    // MARK: - Clear

    func clear() {

        summary = ""
        errorMessage = nil
    }
}
