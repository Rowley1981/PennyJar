import SwiftUI
import Charts

struct CategoryDetailView: View {
    let category: Category
    @State private var showingAddExpense = false
    
    var body: some View {
        List {
            Section("Summary") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Budget")
                        Spacer()
                        Text(category.budgetAmount.formatted(.currency(code: category.budget.currency.code)))
                    }
                    
                    HStack {
                        Text("Spent")
                        Spacer()
                        Text(category.spentAmount.formatted(.currency(code: category.budget.currency.code)))
                    }
                    
                    ProgressView(value: category.spentAmount, total: category.budgetAmount)
                        .tint(category.spentAmount > category.budgetAmount ? .red : .accentColor)
                }
            }
            
            Section("Transactions") {
                if category.transactions.isEmpty {
                    ContentUnavailableView("No Transactions", 
                        systemImage: "doc.text",
                        description: Text("Add your first transaction to start tracking expenses.")
                    )
                } else {
                    ForEach(category.transactions) { transaction in
                        ExpenseRowView(transaction: transaction)
                    }
                }
            }
        }
        .navigationTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add Expense") {
                    showingAddExpense = true
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            NavigationStack {
                AddExpenseView(category: category)
            }
        }
    }
}

struct ExpenseRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            Image(systemName: transaction.category.icon)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 44, height: 44)
                .background(Color.accentColor.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(transaction.category.name)
                    .font(.headline)
                
                if let note = transaction.note {
                    Text(note)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(transaction.amount.formatted(.currency(code: transaction.category.budget.currency.code)))
                .font(.headline)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        CategoryDetailView(
            category: Category(
                name: "Food",
                budgetAmount: 500,
                iconName: "cart.fill",
                iconColor: .green,
                notes: "Monthly food budget",
                expenses: [
                    Expense(amount: 25.99, note: "Groceries", category: Category(name: "Food", budgetAmount: 500, iconName: "cart.fill", iconColor: .green)),
                    Expense(amount: 15.50, note: "Lunch", category: Category(name: "Food", budgetAmount: 500, iconName: "cart.fill", iconColor: .green))
                ]
            )
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("ExpenseRow") {
    ExpenseRowView(
        transaction: Transaction(
            amount: 25.99,
            note: "Groceries",
            category: Category(name: "Food", budgetAmount: 500, iconName: "cart.fill", iconColor: .green)
        )
    )
    .padding()
} 