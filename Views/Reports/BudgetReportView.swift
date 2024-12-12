import SwiftUI
import Charts

struct BudgetReportView: View {
    let budget: Budget
    
    var body: some View {
        List {
            BudgetSummarySection(budget: budget)
            CategoryBreakdownSection(budget: budget)
            SpendingTrendsSection(budget: budget)
        }
        .navigationTitle("Budget Report")
    }
}

private struct BudgetSummarySection: View {
    let budget: Budget
    private var analytics: BudgetAnalytics {
        BudgetAnalytics(budget: budget)
    }
    
    var body: some View {
        Section("Summary") {
            VStack(alignment: .leading, spacing: 8) {
                ProgressView(
                    value: min(analytics.totalSpent / analytics.totalBudget, 1)
                )
                .tint(analytics.remainingBudget >= 0 ? .green : .red)
                
                HStack {
                    Text("\(analytics.percentageSpent, format: .percent)")
                        .font(.caption)
                    Spacer()
                    Text("of budget spent")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            LabeledContent("Total Spent") {
                Text(analytics.totalSpent.formatted(.currency(code: budget.currency.code)))
            }
            
            LabeledContent("Remaining") {
                Text(analytics.remainingBudget.formatted(.currency(code: budget.currency.code)))
                    .foregroundStyle(analytics.remainingBudget >= 0 ? .green : .red)
            }
        }
    }
}

private struct CategoryBreakdownSection: View {
    let budget: Budget
    
    var body: some View {
        Section("Categories") {
            ForEach(budget.categories) { category in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: category.icon)
                            .foregroundStyle(category.color)
                        Text(category.name)
                        Spacer()
                        if let budget = category.budget {
                            Text(category.spent.formatted(.currency(code: budget.currency.code)))
                        }
                    }
                    
                    ProgressView(
                        value: min(category.spent / category.budgetAmount, 1)
                    )
                    .tint(category.color)
                }
            }
        }
    }
}

private struct SpendingTrendsSection: View {
    let budget: Budget
    
    var body: some View {
        Section("Trends") {
            Text("Coming soon...")
                .foregroundStyle(.secondary)
        }
    }
}

enum TimeRangeFilter: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case all = "All Time"
} 