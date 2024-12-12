import SwiftUI
import Charts

struct CategoryDetailView: View {
    let category: Category
    @State private var showingAddExpense = false
    
    var body: some View {
        List {
            Section {
                HStack {
                    Label(category.name, systemImage: category.icon)
                        .foregroundColor(category.color)
                    Spacer()
                    if let budget = category.budget {
                        Text(category.budgetAmount.formatted(.currency(code: budget.currency.code)))
                    }
                }
                
                // ... rest of the view
            }
            
            Section("Transactions") {
                ForEach(category.transactions) { transaction in
                    ExpenseRowView(transaction: transaction)
                }
                .onDelete(perform: deleteTransactions)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddExpense = true
                } label: {
                    Label("Add Expense", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            NavigationStack {
                AddExpenseView(category: category)
            }
        }
    }
    
    private func deleteTransactions(at offsets: IndexSet) {
        offsets.forEach { index in
            let transaction = category.transactions[index]
            category.removeTransaction(transaction)
        }
    }
}

private extension CategoryDetailView {
    static func makePreview() -> some View {
        let budget = Budget(
            name: "Monthly Budget",
            currency: Currency(code: "USD", name: "US Dollar", symbol: "$"),
            frequency: .monthly,
            date: Date()
        )
        
        let category = Category(
            name: "Food",
            budget: budget,
            budgetAmount: 500,
            icon: "cart.fill",
            color: .green
        )
        
        let transaction1 = Transaction(
            amount: 25.99,
            date: Date(),
            note: "Groceries",
            category: category
        )
        
        let transaction2 = Transaction(
            amount: 15.50,
            date: Date(),
            note: "Lunch",
            category: category
        )
        
        category.addTransaction(transaction1)
        category.addTransaction(transaction2)
        
        return NavigationStack {
            CategoryDetailView(category: category)
        }
    }
}

#Preview {
    CategoryDetailView.makePreview()
} 