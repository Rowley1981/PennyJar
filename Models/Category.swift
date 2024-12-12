import SwiftUI

@Observable final class Category: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var budgetAmount: Double
    var icon: String
    var color: Color
    var notes: String?
    weak var budget: Budget?
    private(set) var transactions: [Transaction] = []
    
    enum CodingKeys: String, CodingKey {
        case id, name, budgetAmount, icon, color, notes, transactions
    }
    
    init(id: UUID = UUID(), name: String, budget: Budget, budgetAmount: Double, icon: String, color: Color, notes: String? = nil) {
        self.id = id
        self.name = name
        self.budget = budget
        self.budgetAmount = budgetAmount
        self.icon = icon
        self.color = color
        self.notes = notes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        budgetAmount = try container.decode(Double.self, forKey: .budgetAmount)
        icon = try container.decode(String.self, forKey: .icon)
        
        // Decode Color components
        let colorData = try container.decode(ColorCodable.self, forKey: .color)
        color = colorData.color
        
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        transactions = try container.decode([Transaction].self, forKey: .transactions)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(budgetAmount, forKey: .budgetAmount)
        try container.encode(icon, forKey: .icon)
        try container.encode(ColorCodable(color: color), forKey: .color)
        try container.encodeIfPresent(notes, forKey: .notes)
        try container.encode(transactions, forKey: .transactions)
    }
    
    var spent: Double {
        transactions.reduce(0) { $0 + $1.amount }
    }
    
    var remaining: Double {
        budgetAmount - spent
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
    }
    
    func removeTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
    }
    
    func removeAllTransactions() {
        transactions.removeAll()
    }
    
    // Add Hashable conformance
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Helper struct for Color coding
private struct ColorCodable: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
    
    var color: Color {
        Color(.displayP3, red: red, green: green, blue: blue, opacity: alpha)
    }
    
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.red = Double(red)
        self.green = Double(green)
        self.blue = Double(blue)
        self.alpha = Double(alpha)
    }
}
 