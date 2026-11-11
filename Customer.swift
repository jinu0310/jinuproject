import Foundation

struct WMCustomer: Identifiable, Codable {
    var id: UUID
    var name: String
    var company: String
    var phone: String
    var email: String
    var address: String
    var memo: String

    init(
        id: UUID = UUID(),
        name: String,
        company: String = "",
        phone: String = "",
        email: String = "",
        address: String = "",
        memo: String = ""
    ) {
        self.id = id
        self.name = name
        self.company = company
        self.phone = phone
        self.email = email
        self.address = address
        self.memo = memo
    }
}
