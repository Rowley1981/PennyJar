import Foundation
import SwiftUICore

@Observable final class Budget: Identifiable, Codable {
    let id: UUID
    var name: String
    var currency: Currency
    var frequency: BudgetFrequency
    var date: Date
    private(set) var categories: [Category] = []
    
    var totalBudget: Double {
        categories.reduce(0) { $0 + $1.budgetAmount }
    }
    
    var totalSpent: Double {
        categories.reduce(0) { $0 + $1.spent }
    }
    
    var remaining: Double {
        totalBudget - totalSpent
    }
    
    init(id: UUID = UUID(), name: String, currency: Currency, frequency: BudgetFrequency, date: Date) {
        self.id = id
        self.name = name
        self.currency = currency
        self.frequency = frequency
        self.date = date
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
    }
    
    func removeCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
    }
    
    func resetExpenses() {
        categories.forEach { category in
            category.removeAllTransactions()
        }
    }
    
    func addTransaction(_ transaction: Transaction, to category: Category) {
        guard let index = categories.firstIndex(where: { $0.id == category.id }) else { return }
        categories[index].addTransaction(transaction)
    }
    
    func dateRange() -> ClosedRange<Date> {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let start: Date
        let end: Date
        
        switch frequency {
        case .daily:
            start = calendar.date(from: components) ?? date
            end = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: start) ?? date
        case .weekly:
            var comp = components
            comp.day = comp.day! - (calendar.component(.weekday, from: date) - 1)
            start = calendar.date(from: comp) ?? date
            end = calendar.date(byAdding: DateComponents(day: 7, second: -1), to: start) ?? date
        case .monthly:
            var comp = components
            comp.day = 1
            start = calendar.date(from: comp) ?? date
            end = calendar.date(byAdding: DateComponents(month: 1, second: -1), to: start) ?? date
        case .yearly:
            var comp = components
            comp.day = 1
            comp.month = 1
            start = calendar.date(from: comp) ?? date
            end = calendar.date(byAdding: DateComponents(year: 1, second: -1), to: start) ?? date
        }
        
        return start...end
    }
}
