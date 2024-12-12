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