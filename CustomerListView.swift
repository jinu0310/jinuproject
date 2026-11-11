import SwiftUI

struct CustomerListView: View {
    @State private var customers: [Customer] = []

    var body: some View {
        List(customers) { customer in
            NavigationLink(customer.name) {
                CustomerDetailView(customer: customer)
            }
        }
        .navigationTitle("고객")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) { Image(systemName: "plus") }
            }
        }
    }
}
