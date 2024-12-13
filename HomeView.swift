struct HomeView: View {
    @Environment(BudgetStore.self) private var budgetStore
    @Environment(TransactionStore.self) private var transactionStore
    @State private var showingAddTransaction = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Budget Summary Section
                    BudgetSummaryView(budgets: budgetStore.budgets)
                    
                    // Recent Transactions Section
                    Section {
                        TransactionListView(
                            transactions: transactionStore.recentTransactions
                        )
                    } header: {
                        HStack {
                            Text("Recent Transactions")
                                .font(.headline)
                            Spacer()
                            Button("Add") {
                                showingAddTransaction = true
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView()
        }
    }
} 