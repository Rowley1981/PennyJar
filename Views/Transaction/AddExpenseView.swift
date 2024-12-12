import SwiftUI

struct AddExpenseView: View {
    let category: Category
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount = 0.0
    @State private var note = ""
    @State private var date = Date()
    
    private var dateRange: ClosedRange<Date> {
        if let budget = category.budget {
            return budget.dateRange()
        }
        return Date()...Date()
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text(category.budget?.currency.symbol ?? "$")
                    TextField("Amount", value: $amount, format: .number)
                        .keyboardType(.decimalPad)
                }
                
                TextField("Note", text: $note)
                
                DatePicker(
                    "Date",
                    selection: $date,
                    in: dateRange,
                    displayedComponents: [.date]
                )
            }
        }
        .navigationTitle("Add Expense")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    addExpense()
                }
                .disabled(amount <= 0)
            }
        }
    }
    
    private func addExpense() {
        let transaction = Transaction(
            amount: amount,
            date: date,
            note: note,
            category: category
        )
        if let budget = category.budget {
            budget.addTransaction(transaction, to: category)
        }
        dismiss()
    }
} 
