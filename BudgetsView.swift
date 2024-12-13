struct BudgetsView: View {
    @Environment(BudgetStore.self) private var store
    @State private var showingAddBudget = false
    
    var groupedBudgets: [(Category, [Budget])] {
        Dictionary(grouping: store.budgets) { $0.category }
            .map { ($0.key, $0.value) }
            .sorted { $0.0.rawValue < $1.0.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedBudgets, id: \.0) { category, budgets in
                    Section(category.rawValue) {
                        ForEach(budgets) { budget in
                            NavigationLink(value: budget) {
                                BudgetRowView(budget: budget)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Budgets")
            .navigationDestination(for: Budget.self) { budget in
                BudgetDetailView(budget: budget)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Budget") {
                        showingAddBudget = true
                    }
                }
            }
            .sheet(isPresented: $showingAddBudget) {
                AddBudgetView()
            }
        }
    }
}

struct BudgetRowView: View {
    let budget: Budget
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(budget.name)
                    .font(.headline)
                Spacer()
                Text(budget.amount, format: .currency(code: "USD"))
            }
            
            BudgetProgressView(spent: budget.spent, total: budget.amount)
        }
    }
} 