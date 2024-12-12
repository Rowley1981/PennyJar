import Foundation

@Observable final class BudgetPeriod: Identifiable, Codable {
    let id: UUID
    var startDate: Date
    var endDate: Date
    var transactions: [Transaction]
    
    init(id: UUID = UUID(), startDate: Date, endDate: Date, transactions: [Transaction] = []) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.transactions = transactions
    }
} 