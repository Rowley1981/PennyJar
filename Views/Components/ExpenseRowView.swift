import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.note.isEmpty ? "Expense" : expense.note)
                Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(expense.amount, format: .currency(code: expense.category.currency.code))
        }
    }
}

#Preview {
    ExpenseRowView(
        expense: Expense(
            amount: 25.99,
            note: "Groceries",
            category: Category(name: "Food", budgetAmount: 500, iconName: "cart.fill", iconColor: .green)
        )
    )
    .padding()
} 