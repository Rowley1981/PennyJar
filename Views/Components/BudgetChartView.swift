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
    BudgetChartView(
        budget: Budget(
            name: "Monthly Budget",
            currency: Currency(code: "USD", name: "US Dollar", symbol: "$"),
            frequency: .monthly,
            date: Date()
        )
    )
} 