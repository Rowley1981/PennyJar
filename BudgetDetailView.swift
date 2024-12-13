struct BudgetDetailView: View {
    let budget: Budget
    @State private var isEditViewPresented = false
    @Environment(TransactionStore.self) private var transactionStore
    
    var budgetTransactions: [Transaction] {
        transactionStore.transactions.filter { $0.budgetId == budget.id }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Budget Progress Section
                BudgetProgressView(spent: budget.spent, total: budget.amount)
                    .padding()
                
                // Transactions Section
                VStack(alignment: .leading) {
                    Text("Transactions")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    TransactionListView(transactions: budgetTransactions)
                }
            }
        }
        .navigationTitle(budget.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isEditViewPresented = true
                }
            }
        }
        .sheet(isPresented: $isEditViewPresented) {
            EditBudgetView(budget: budget)
        }
    }
} 