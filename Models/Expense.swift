import Foundation

struct Expense: Identifiable, Codable {
    let id: UUID
    var amount: Decimal
    var date: Date
    var note: String
    let category: Category
    
    init(id: UUID = UUID(), amount: Decimal, date: Date = Date(), note: String = "", category: Category) {
        self.id = id
        self.amount = amount
        self.date = date
        self.note = note
        self.category = category
    }
} 