import SwiftUI
import Charts

struct SpendingTrendChart: View {
    let expenses: [Expense]
    let budgetAmount: Decimal
    let color: Color
    
    var body: some View {
        Chart {
            ForEach(expenses.sorted(by: { $0.date < $1.date }), id: \.id) { expense in
                LineMark(
                    x: .value("Date", expense.date),
                    y: .value("Amount", expense.amount)
                )
                .foregroundStyle(color)
                
                PointMark(
                    x: .value("Date", expense.date),
                    y: .value("Amount", expense.amount)
                )
                .foregroundStyle(color)
            }
            
            RuleMark(
                y: .value("Budget", NSDecimalNumber(decimal: budgetAmount).doubleValue)
            )
            .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
            .foregroundStyle(Theme.accent)
        }
        .frame(height: 200)
        .padding()
        .cardStyle()
    }
}

#Preview {
    let budget = Budget(name: "December 2024", currency: .gbp, frequency: .monthly, date: .now)
    let groceriesCategory = Category(
        name: "Groceries",
        budget: budget,
        budgetAmount: 500,
        icon: "cart",
        color: .green
    )
    
    SpendingTrendChart(
        expenses: [
            Expense(amount: 25.99, date: .now, note: "Groceries", category: groceriesCategory),
            Expense(amount: 45.00, date: .now.addingTimeInterval(-86400), note: "Transport", category: groceriesCategory),
            Expense(amount: 15.00, date: .now.addingTimeInterval(-172800), note: "Coffee", category: groceriesCategory),
            Expense(amount: 89.99, date: .now.addingTimeInterval(-259200), note: "Shopping", category: groceriesCategory)
        ],
        budgetAmount: 500,
        color: .blue
    )
    .frame(height: 200)
    .padding()
} 