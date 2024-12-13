struct AddBudgetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(BudgetStore.self) private var store
    
    @State private var name = ""
    @State private var amount = 0.0
    @State private var category = Category.other
    
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
            .navigationTitle("Add Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let budget = Budget(
                            name: name,
                            amount: amount,
                            category: category
                        )
                        store.addBudget(budget)
                        dismiss()
                    }
                }
            }
        }
    }
} 