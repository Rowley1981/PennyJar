// Add navigation to EditBudgetView
.toolbar {
    ToolbarItem(placement: .navigationBarTrailing) {
        Button("Edit") {
            // Present EditBudgetView
            isEditViewPresented = true
        }
    }
}
.sheet(isPresented: $isEditViewPresented) {
    EditBudgetView(budget: budget)
}

// Add progress view
BudgetProgressView(spent: budget.spent, total: budget.amount) 