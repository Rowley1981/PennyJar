import SwiftUI

@Observable final class BudgetStore: Codable {
    var budgets: [Budget]
    private let saveKey = "budgets"
    
    init(budgets: [Budget] = []) {
        self.budgets = budgets
        load()
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Failed to save budgets: \(error)")
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        do {
            let store = try JSONDecoder().decode(BudgetStore.self, from: data)
            self.budgets = store.budgets
        } catch {
            print("Failed to load budgets: \(error)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case budgets
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        budgets = try container.decode([Budget].self, forKey: .budgets)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(budgets, forKey: .budgets)
    }
    
    func addBudget(_ budget: Budget) {
        budgets.append(budget)
        save()
    }
    
    func deleteBudget(_ budget: Budget) {
        budgets.removeAll { $0.id == budget.id }
        save()
    }
} 