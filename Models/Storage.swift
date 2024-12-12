import Foundation

final class Storage {
    static let shared = Storage()
    private let defaults = UserDefaults.standard
    
    private let budgetStoreKey = "budgetStore"
    
    private init() {} // Make init private for singleton
    
    func save(_ budgetStore: BudgetStore) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(budgetStore)
            defaults.set(data, forKey: budgetStoreKey)
        } catch {
            print("Failed to save budget store: \(error.localizedDescription)")
        }
    }
    
    func loadBudgetStore() -> BudgetStore {
        guard let data = defaults.data(forKey: budgetStoreKey) else {
            return BudgetStore()
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(BudgetStore.self, from: data)
        } catch {
            print("Failed to load budget store: \(error.localizedDescription)")
            return BudgetStore()
        }
    }
} 