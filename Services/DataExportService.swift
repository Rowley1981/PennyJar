import Foundation

enum ExportFormat {
    case json
    case csv
}

class DataExportService {
    static let shared = DataExportService()
    
    func exportBudget(_ budget: Budget, format: ExportFormat) throws -> Data {
        switch format {
        case .json:
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return try encoder.encode(budget)
            
        case .csv:
            var csv = "Date,Category,Amount,Note\n"
            
            for period in budget.periods {
                for category in period.categories {
                    for transaction in category.transactions {
                        let date = transaction.date.formatted(date: .numeric, time: .omitted)
                        let amount = String(format: "%.2f", transaction.amount)
                        let note = transaction.note.replacingOccurrences(of: ",", with: ";")
                        
                        csv += "\(date),\(category.name),\(amount),\(note)\n"
                    }
                }
            }
            
            return csv.data(using: .utf8) ?? Data()
        }
    }
    
    func importBudget(from data: Data, format: ExportFormat) throws -> Budget {
        switch format {
        case .json:
            let decoder = JSONDecoder()
            return try decoder.decode(Budget.self, from: data)
            
        case .csv:
            // Create a new budget
            let budget = Budget(
                name: "Imported Budget",
                currency: Currency(code: "USD", name: "US Dollar", symbol: "$"),
                frequency: .monthly,
                date: Date()
            )
            
            guard let csv = String(data: data, encoding: .utf8) else {
                throw ValidationError.invalidCategory
            }
            
            let rows = csv.components(separatedBy: "\n")
            var categories: [String: Category] = [:]
            
            // Skip header row
            for row in rows.dropFirst() where !row.isEmpty {
                let columns = row.components(separatedBy: ",")
                guard columns.count == 4 else { continue }
                
                let date = DateFormatter().date(from: columns[0]) ?? Date()
                let categoryName = columns[1]
                let amount = Double(columns[2]) ?? 0
                let note = columns[3]
                
                if categories[categoryName] == nil {
                    categories[categoryName] = Category(
                        name: categoryName,
                        budgetAmount: amount,
                        iconName: "dollarsign.circle",
                        iconColor: .blue
                    )
                }
                
                if let category = categories[categoryName] {
                    let transaction = Transaction(
                        date: date,
                        amount: amount,
                        note: note,
                        categoryId: category.id
                    )
                    var updatedCategory = category
                    updatedCategory.transactions.append(transaction)
                    categories[categoryName] = updatedCategory
                }
            }
            
            categories.values.forEach { budget.addCategory($0) }
            return budget
        }
    }
} 