import Foundation

enum TaskPriority: String, Codable, CaseIterable, Identifiable {
    case low = "낮음"
    case medium = "보통"
    case high = "높음"

    var id: String { rawValue }
}

struct WMTask: Identifiable, Codable {
    var id: UUID
    var title: String
    var detail: String
    var customerName: String
    var dueDate: Date
    var priority: TaskPriority
    var isDone: Bool

    init(
        id: UUID = UUID(),
        title: String,
        detail: String = "",
        customerName: String = "",
        dueDate: Date = Date(),
        priority: TaskPriority = .medium,
        isDone: Bool = false
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.customerName = customerName
        self.dueDate = dueDate
        self.priority = priority
        self.isDone = isDone
    }
}
