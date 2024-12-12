import Foundation

struct Transaction: Identifiable, Codable {
    let id: UUID
    let amount: Double
    let date: Date
    let note: String
    weak var category: Category?
    
    init(id: UUID = UUID(), amount: Double, date: Date, note: String, category: Category?) {
        self.id = id
        self.amount = amount
        self.date = date
        self.note = note
        self.category = category
    }
} 