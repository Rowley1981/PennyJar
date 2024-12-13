@Observable final class Budget {
    var name: String
    var amount: Double
    var spent: Double
    var remaining: Double
    var category: Category
    var transactions: [Transaction]
    var id: UUID
    
    init(name: String, amount: Double, spent: Double = 0.0, remaining: Double = 0.0, category: Category, transactions: [Transaction] = [], id: UUID = UUID()) {
        self.name = name
        self.amount = amount
        self.spent = spent
        self.remaining = remaining
        self.category = category
        self.transactions = transactions
        self.id = id
    }
}

extension Budget: Identifiable {}

extension Budget: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case amount
        case spent
        case remaining
        case category
        case transactions
        case id
    }
} 