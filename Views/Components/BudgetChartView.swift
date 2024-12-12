import SwiftUI
import Charts

struct BudgetChartView: View {
    let budget: Budget
    
    var body: some View {
        Chart {
            ForEach(budget.categories) { category in
                BarMark(
                    x: .value("Category", category.name),
                    y: .value("Amount", category.spent)
                )
                .foregroundStyle(category.color)
            }
        }
        .frame(height: 200)
    }
}

#Preview {
    let budget = Budget(name: "December 2024", currency: .gbp, frequency: .monthly, date: .now)
    BudgetChartView(budget: budget)
} 