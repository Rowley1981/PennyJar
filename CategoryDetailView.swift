struct CategoryDetailView: View {
    let category: Category
    @Environment(BudgetStore.self) private var budgetStore
    @Environment(TransactionStore.self) private var transactionStore
    @State private var showingAddTransaction = false
    
    var categoryBudgets: [Budget] {
        budgetStore.budgets.filter { $0.category == category }
    }
    
    var categoryTransactions: [Transaction] {
        transactionStore.transactions.filter { transaction in
            guard let budgetId = transaction.budgetId else { return false }
            return categoryBudgets.contains { $0.id == budgetId }
        }
    }
    
    var body: some View {
        List {
            Section("Budgets") {
                ForEach(categoryBudgets) { budget in
                    NavigationLink(value: budget) {
                        BudgetRowView(budget: budget)
                    }
                }
            }
            
            Section("Transactions") {
                if categoryTransactions.isEmpty {
                    ContentUnavailableView("No Transactions",
                        systemImage: "creditcard",
                        description: Text("Add a transaction to get started"))
                } else {
                    ForEach(categoryTransactions) { transaction in
                        NavigationLink(value: transaction) {
                            TransactionRowView(transaction: transaction)
                        }
                    }
                }
            }
        }
        .navigationTitle(category.rawValue)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add Transaction") {
                    showingAddTransaction = true
                }
            }
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView()
        }
    }
} 