import Foundation
import FoundationModels

@available(iOS 26.0, *)
@MainActor
final class OnDeviceAIService: ObservableObject {

    @Published var isGenerating = false
    @Published var errorMessage: String?

    private let session = LanguageModelSession()

    // MARK: - Availability

    var isAvailable: Bool {

        SystemLanguageModel.default.availability == .available
    }

    // MARK: - Generate Text

    func generateText(
        prompt: String
    ) async -> String? {

        guard isAvailable else {

            errorMessage = "현재 기기에서 온디바이스 AI를 사용할 수 없습니다."

            return nil
        }

        guard !prompt.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {

            errorMessage = "AI에게 전달할 내용을 입력해 주세요."

            return nil
        }

        isGenerating = true
        errorMessage = nil

        defer {
            isGenerating = false
        }

        do {

            let response = try await session.respond(
                to: prompt
            )

            return response.content

        } catch {

            errorMessage = "AI 응답 생성에 실패했습니다: \(error.localizedDescription)"

            return nil
        }
    }

    // MARK: - Work Summary

    func summarizeWork(
        text: String
    ) async -> String? {

        let prompt = """
        당신은 한국의 소규모 사업장을 위한 업무 관리 AI입니다.

        아래 업무 기록을 읽고 이해하기 쉬운 한국어로 정리하세요.

        다음 항목을 중심으로 작성하세요.

        1. 작업 내용
        2. 작업 진행 상황
        3. 사용 자재 및 장비
        4. 문제 및 특이사항
        5. 후속 조치

        확인되지 않은 사실은 임의로 만들어내지 마세요.

        업무 기록:
        \(text)
        """

        return await generateText(prompt: prompt)
    }

    // MARK: - Customer Message

    func improveWorkMemo(
        text: String
    ) async -> String? {

        let prompt = """
        다음 업무 메모를 전문적이고 자연스러운 한국어로 다듬어 주세요.

        원래 의미와 사실은 유지하고,
        불필요한 표현만 정리해 주세요.

        업무 메모:
        \(text)
        """

        return await generateText(prompt: prompt)
    }
}
