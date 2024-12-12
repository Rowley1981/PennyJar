import Foundation

@Observable final class BudgetStore {
    private(set) var budgets: [Budget] = []
    private let saveKey = "SavedBudgets"
    
    init() {
        loadBudgets()
    }
    
    func addBudget(_ budget: Budget) {
        budgets.append(budget)
        saveBudgets()
    }
    
    func deleteBudget(_ budget: Budget) {
        budgets.removeAll { $0.id == budget.id }
        saveBudgets()
    }
    
    private func loadBudgets() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        
        do {
            let decoder = JSONDecoder()
            budgets = try decoder.decode([Budget].self, from: data)
        } catch {
            print("Error loading budgets: \(error)")
        }
    }
    
    private func saveBudgets() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(budgets)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Error saving budgets: \(error)")
        }
    }
} 