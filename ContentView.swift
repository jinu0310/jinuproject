import SwiftUI

struct CustomerListView: View {

    @EnvironmentObject var appStore: AppStore

    @State private var searchText = ""
    @State private var showingEditor = false

    private var filteredCustomers: [WMCustomer] {

        appStore.customers.filter { customer in

            searchText.isEmpty ||
            customer.name.localizedCaseInsensitiveContains(searchText) ||
            customer.company.localizedCaseInsensitiveContains(searchText) ||
            customer.phone.localizedCaseInsensitiveContains(searchText)
        }
        .sorted {
            $0.name.localizedCompare($1.name) == .orderedAscending
        }
    }

    var body: some View {

        NavigationStack {

            List {

                Section {

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(appStore.totalCustomerCount)")
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Text("등록된 고객")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "person.2.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(AppTheme.Colors.accent)
                    }
                    .padding(.vertical, 8)
                }

                Section("고객 목록") {

                    if filteredCustomers.isEmpty {

                        ContentUnavailableView.search(
                            text: searchText
                        )

                    } else {

                        ForEach(filteredCustomers) { customer in

                            NavigationLink {
                                CustomerDetailView(customer: customer)
                            } label: {

                                customerRow(customer)
                            }
                        }
                        .onDelete(perform: deleteCustomers)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("고객")
            .searchable(
                text: $searchText,
                prompt: "이름, 업체, 연락처 검색"
            )
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button {
                        showingEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingEditor) {
                CustomerEditorView()
            }
        }
    }

    // MARK: - Customer Row

    private func customerRow(
        _ customer: WMCustomer
    ) -> some View {

        HStack(spacing: 12) {

            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 38))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 5) {

                Text(customer.name)
                    .fontWeight(.semibold)

                Text(
                    customer.company.isEmpty
                    ? customer.phone
                    : customer.company
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }

    // MARK: - Delete

    private func deleteCustomers(at offsets: IndexSet) {

        let customersToDelete = offsets.map {
            filteredCustomers[$0]
        }

        for customer in customersToDelete {
            appStore.deleteCustomer(customer)
        }
    }
}
