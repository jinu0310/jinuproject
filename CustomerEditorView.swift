import SwiftUI

struct CustomerEditorView: View {

    @EnvironmentObject var appStore: AppStore
    @Environment(\.dismiss) private var dismiss

    let customer: WMCustomer?

    @State private var name: String
    @State private var phone: String
    @State private var company: String
    @State private var address: String
    @State private var memo: String

    init(customer: WMCustomer? = nil) {

        self.customer = customer

        _name = State(initialValue: customer?.name ?? "")
        _phone = State(initialValue: customer?.phone ?? "")
        _company = State(initialValue: customer?.company ?? "")
        _address = State(initialValue: customer?.address ?? "")
        _memo = State(initialValue: customer?.memo ?? "")
    }

    var body: some View {

        NavigationStack {

            Form {

                Section("기본 정보") {

                    TextField("고객 이름", text: $name)

                    TextField("전화번호", text: $phone)
                        .keyboardType(.phonePad)

                    TextField("업체명", text: $company)
                }

                Section("주소") {

                    TextField("주소 입력", text: $address)
                }

                Section("고객 메모") {

                    TextEditor(text: $memo)
                        .frame(minHeight: 130)
                }
            }
            .navigationTitle(
                customer == nil ? "새 고객" : "고객 수정"
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {

                    Button("취소") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {

                    Button("저장") {
                        saveCustomer()
                    }
                    .fontWeight(.semibold)
                    .disabled(
                        name.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                }
            }
        }
    }

    // MARK: - Save

    private func saveCustomer() {

        if var existingCustomer = customer {

            existingCustomer.name = name
            existingCustomer.phone = phone
            existingCustomer.company = company
            existingCustomer.address = address
            existingCustomer.memo = memo

            appStore.updateCustomer(existingCustomer)

        } else {

            let newCustomer = WMCustomer(
                name: name,
                phone: phone,
                company: company,
                address: address,
                memo: memo
            )

            appStore.addCustomer(newCustomer)
        }

        dismiss()
    }
}
