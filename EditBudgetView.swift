struct EditBudgetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(BudgetStore.self) private var store
    
    let budget: Budget
    @State private var name: String
    @State private var amount: Double
    @State private var category: Category
    
    init(budget: Budget) {
        self.budget = budget
        _name = State(initialValue: budget.name)
        _amount = State(initialValue: budget.amount)
        _category = State(initialValue: budget.category)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                
                Picker("Category", selection: $category) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
            }
            .navigationTitle("Edit Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.updateBudget(budget, name: name, amount: amount, category: category)
                        dismiss()
                    }
                }
            }
        }
    }
} 