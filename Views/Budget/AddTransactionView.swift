import SwiftUI

struct AddTransactionView: View {
    let budget: Budget
    let category: Category
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount = 0.0
    @State private var date = Date()
    @State private var note = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text(budget.currency.symbol)
                        TextField("Amount", value: $amount, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                }
                
                Section {
                    TextField("Note", text: $note)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let transaction = Transaction(
                            date: date,
                            amount: amount,
                            note: note,
                            categoryId: category.id
                        )
                        var updatedCategory = category
                        updatedCategory.transactions.append(transaction)
                        budget.updateCategory(updatedCategory)
                        dismiss()
                    }
                    .disabled(amount <= 0)
                }
            }
        }
    }
} 