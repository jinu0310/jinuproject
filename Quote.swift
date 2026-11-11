import Foundation

enum QuoteStatus: String, Codable, CaseIterable, Identifiable {
    case draft = "작성 중"
    case sent = "전송 완료"
    case approved = "승인"
    case rejected = "거절"

    var id: String { rawValue }
}

struct WMQuoteItem: Identifiable, Codable {
    var id: UUID
    var name: String
    var quantity: Int
    var unitPrice: Int

    var total: Int {
        quantity * unitPrice
    }

    init(
        id: UUID = UUID(),
        name: String,
        quantity: Int = 1,
        unitPrice: Int = 0
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unitPrice = unitPrice
    }
}

struct WMQuote: Identifiable, Codable {
    var id: UUID
    var title: String
    var customerName: String
    var items: [WMQuoteItem]
    var status: QuoteStatus
    var createdAt: Date
    var memo: String

    var totalAmount: Int {
        items.reduce(0) { $0 + $1.total }
    }

    init(
        id: UUID = UUID(),
        title: String,
        customerName: String = "",
        items: [WMQuoteItem] = [],
        status: QuoteStatus = .draft,
        createdAt: Date = Date(),
        memo: String = ""
    ) {
        self.id = id
        self.title = title
        self.customerName = customerName
        self.items = items
        self.status = status
        self.createdAt = createdAt
        self.memo = memo
    }
}
