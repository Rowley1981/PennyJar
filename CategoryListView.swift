struct CategoryListView: View {
    @Environment(BudgetStore.self) private var budgetStore
    @State private var showingAddCategory = false
    
    var body: some View {
        List {
            ForEach(Category.allCases, id: \.self) { category in
                HStack {
                    Text(category.rawValue)
                    Spacer()
                    Text("\(budgetStore.budgets.filter { $0.category == category }.count) budgets")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    showingAddCategory = true
                }
            }
        }
    }
} 