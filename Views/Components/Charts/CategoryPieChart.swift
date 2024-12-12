import SwiftUI
import Charts

struct CategoryPieChart: View {
    let categories: [Category]
    
    var body: some View {
        Chart {
            ForEach(categories) { category in
                SectorMark(
                    angle: .value("Spent", category.spent),
                    innerRadius: .ratio(0.618),
                    angularInset: 1
                )
                .foregroundStyle(category.color)
                .annotation(position: .overlay) {
                    Text(category.name)
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(height: 300)
        .padding()
        .cardStyle()
    }
}

#Preview {
    let budget = Budget(name: "December 2024", currency: .gbp, frequency: .monthly, date: .now)
    CategoryPieChart(categories: [
        Category(name: "Groceries", budget: budget, budgetAmount: 500, icon: "cart", color: .green),
        Category(name: "Transport", budget: budget, budgetAmount: 200, icon: "bus", color: .blue),
        Category(name: "Entertainment", budget: budget, budgetAmount: 300, icon: "film", color: .purple)
    ])
} 