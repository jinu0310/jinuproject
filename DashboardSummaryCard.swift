import SwiftUI

struct DashboardSummaryCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.title2.bold())
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
    }
}
