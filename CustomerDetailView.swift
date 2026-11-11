import SwiftUI

struct CustomerDetailView: View {

    @EnvironmentObject var appStore: AppStore

    @State private var showingEditor = false

    let customer: WMCustomer

    private var currentCustomer: WMCustomer {
        appStore.customers.first {
            $0.id == customer.id
        } ?? customer
    }

    var body: some View {

        List {

            // MARK: - Customer Profile

            Section {

                VStack(spacing: 12) {

                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 68))
                        .foregroundStyle(AppTheme.Colors.accent)

                    Text(currentCustomer.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    if !currentCustomer.company.isEmpty {
                        Text(currentCustomer.company)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            }

            // MARK: - Contact Information

            Section("연락처 정보") {

                detailRow(
                    title: "전화번호",
                    value: currentCustomer.phone
                )

                detailRow(
                    title: "업체명",
                    value: currentCustomer.company
                )

                detailRow(
                    title: "주소",
                    value: currentCustomer.address
                )
            }

            // MARK: - Memo

            Section("고객 메모") {

                if currentCustomer.memo.isEmpty {

                    Text("등록된 메모가 없습니다.")
                        .foregroundStyle(.secondary)

                } else {

                    Text(currentCustomer.memo)
                }
            }

            // MARK: - Registration Date

            Section("등록 정보") {

                HStack {
                    Text("등록 일자")

                    Spacer()

                    Text(
                        currentCustomer.createdAt,
                        format: .dateTime
                            .year()
                            .month()
                            .day()
                    )
                    .foregroundStyle(.secondary)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("고객 상세")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            ToolbarItem(placement: .topBarTrailing) {

                Button("편집") {
                    showingEditor = true
                }
            }
        }
        .sheet(isPresented: $showingEditor) {
            CustomerEditorView(customer: currentCustomer)
        }
    }

    // MARK: - Detail Row

    private func detailRow(
        title: String,
        value: String
    ) -> some View {

        HStack {

            Text(title)

            Spacer()

            Text(value.isEmpty ? "-" : value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}
