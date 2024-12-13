struct TransactionDetailView: View {
    let transaction: Transaction
    @Environment(BudgetStore.self) private var budgetStore
    
    var associatedBudget: Budget? {
        guard let budgetId = transaction.budgetId else { return nil }
        return budgetStore.budgets.first { $0.id == budgetId }
    }
    
    var body: some View {
        List {
            Section("Details") {
                LabeledContent("Name", value: transaction.name)
                LabeledContent("Amount", value: transaction.amount, format: .currency(code: "USD"))
                LabeledContent("Date", value: transaction.date, format: .dateTime)
                if let budget = associatedBudget {
                    LabeledContent("Budget", value: budget.name)
                }
            }
        }
        .navigationTitle("Transaction Details")
    }
} 