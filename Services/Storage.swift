import Foundation

class Storage {
    static let shared = Storage()
    private let fileManager = FileManager.default
    
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var budgetStoreURL: URL {
        documentsDirectory.appendingPathComponent("budgetStore.json")
    }
    
    func loadBudgetStore() -> BudgetStore {
        do {
            let data = try Data(contentsOf: budgetStoreURL)
            let decoder = JSONDecoder()
            return try decoder.decode(BudgetStore.self, from: data)
        } catch {
            print("Error loading budget store: \(error)")
            return BudgetStore()
        }
    }
    
    func save(_ budgetStore: BudgetStore) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(budgetStore)
            try data.write(to: budgetStoreURL)
        } catch {
            print("Error saving budget store: \(error)")
        }
    }
} 