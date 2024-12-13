struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(TransactionStore.self) private var transactionStore
    @Environment(BudgetStore.self) private var budgetStore
    
    @State private var name = ""
    @State private var amount = 0.0
    @State private var date = Date()
    @State private var selectedBudgetId: Budget.ID?
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                
                DatePicker("Date", selection: $date, displayedComponents: [.date])
                
                Picker("Budget", selection: $selectedBudgetId) {
                    Text("None").tag(Optional<UUID>.none)
                    ForEach(budgetStore.budgets) { budget in
                        Text(budget.name).tag(Optional(budget.id))
                    }
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
                            name: name,
                            amount: amount,
                            date: date,
                            budgetId: selectedBudgetId
                        )
                        transactionStore.addTransaction(transaction)
                        dismiss()
                    }
                }
            }
        }
    }
} 