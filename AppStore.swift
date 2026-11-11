import Foundation
import Combine

final class AppStore: ObservableObject {

    @Published var tasks: [WMTask] = []
    @Published var customers: [WMCustomer] = []
    @Published var quotes: [WMQuote] = []

    private struct StoreData: Codable {
        var tasks: [WMTask]
        var customers: [WMCustomer]
        var quotes: [WMQuote]
    }

    private var storageURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("WorkmateAI_Data.json")
    }

    init() {
        loadData()
    }

    private func saveData() {
        let storeData = StoreData(
            tasks: tasks,
            customers: customers,
            quotes: quotes
        )

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601

            let data = try encoder.encode(storeData)
            try data.write(to: storageURL, options: .atomic)
        } catch {
            print("저장 오류: \(error.localizedDescription)")
        }
    }

    private func loadData() {
        guard FileManager.default.fileExists(
            atPath: storageURL.path
        ) else {
            return
        }

        do {
            let data = try Data(contentsOf: storageURL)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let storedData = try decoder.decode(
                StoreData.self,
                from: data
            )

            tasks = storedData.tasks
            customers = storedData.customers
            quotes = storedData.quotes

        } catch {
            print("불러오기 오류: \(error.localizedDescription)")
        }
    }

    // MARK: - Tasks

    func addTask(_ task: WMTask) {
        tasks.append(task)
        saveData()
    }

    func updateTask(_ task: WMTask) {
        guard let index = tasks.firstIndex(
            where: { $0.id == task.id }
        ) else { return }

        tasks[index] = task
        saveData()
    }

    func deleteTask(_ task: WMTask) {
        tasks.removeAll { $0.id == task.id }
        saveData()
    }

    // MARK: - Customers

    func addCustomer(_ customer: WMCustomer) {
        customers.append(customer)
        saveData()
    }

    func updateCustomer(_ customer: WMCustomer) {
        guard let index = customers.firstIndex(
            where: { $0.id == customer.id }
        ) else { return }

        customers[index] = customer
        saveData()
    }

    func deleteCustomer(_ customer: WMCustomer) {
        customers.removeAll { $0.id == customer.id }
        saveData()
    }

    // MARK: - Quotes

    func addQuote(_ quote: WMQuote) {
        quotes.append(quote)
        saveData()
    }

    func updateQuote(_ quote: WMQuote) {
        guard let index = quotes.firstIndex(
            where: { $0.id == quote.id }
        ) else { return }

        quotes[index] = quote
        saveData()
    }

    func deleteQuote(_ quote: WMQuote) {
        quotes.removeAll { $0.id == quote.id }
        saveData()
    }

    // MARK: - Statistics

    var totalTaskCount: Int {
        tasks.count
    }

    var completedTaskCount: Int {
        tasks.filter { $0.isDone }.count
    }

    var pendingTaskCount: Int {
        tasks.filter { !$0.isDone }.count
    }

    var totalCustomerCount: Int {
        customers.count
    }

    var totalQuoteCount: Int {
        quotes.count
    }

    // MARK: - Data Management

    func clearAllData() {
        tasks.removeAll()
        customers.removeAll()
        quotes.removeAll()
        saveData()
    }
}
