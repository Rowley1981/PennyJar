import SwiftUI

struct ExpenseRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            if let category = transaction.category {
                Image(systemName: category.icon)
                    .frame(width: 30, height: 30)
                    .foregroundColor(category.color)
                    .padding(8)
                    .background(category.color.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading) {
                Text(transaction.note)
                    .font(.headline)
                Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let category = transaction.category,
               let budget = category.budget {
                Text(transaction.amount.formatted(.currency(code: budget.currency.code)))
                    .font(.headline)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
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
    
    let transaction = Transaction(
        id: UUID(),
        amount: 25.99,
        date: Date(),
        note: "Groceries",
        category: category
    )
    
    ExpenseRowView(transaction: transaction)
        .padding()
} 