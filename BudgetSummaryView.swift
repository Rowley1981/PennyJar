struct BudgetSummaryView: View {
    let budgets: [Budget]
    
    private var totalBudget: Double {
        budgets.reduce(0) { $0 + $1.amount }
    }
    
    private var totalSpent: Double {
        budgets.reduce(0) { $0 + $1.spent }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Budget Summary")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Budget")
                        .foregroundStyle(.secondary)
                    Text(totalBudget, format: .currency(code: "USD"))
                        .font(.title2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Total Spent")
                        .foregroundStyle(.secondary)
                    Text(totalSpent, format: .currency(code: "USD"))
                        .font(.title2)
                }
            }
            
            ProgressView(value: totalSpent, total: totalBudget)
                .tint(totalSpent > totalBudget ? .red : .green)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
} 