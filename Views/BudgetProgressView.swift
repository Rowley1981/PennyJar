import SwiftUI

struct BudgetProgressView: View {
    let budget: Budget
    private var analytics: BudgetAnalytics {
        BudgetAnalytics(budget: budget)
    }
    
    var body: some View {
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
    }
}

struct TotalSpentRow: View {
    let budget: Budget
    
    private var analytics: BudgetAnalytics {
        BudgetAnalytics(budget: budget)
    }
    
    var body: some View {
        LabeledContent("Total Spent") {
            Text(analytics.totalSpent.formatted(.currency(code: budget.currency.code)))
        }
    }
}

struct RemainingBudgetRow: View {
    let budget: Budget
    
    private var analytics: BudgetAnalytics {
        BudgetAnalytics(budget: budget)
    }
    
    var body: some View {
        LabeledContent("Remaining") {
            Text(analytics.remainingBudget.formatted(.currency(code: budget.currency.code)))
                .foregroundStyle(analytics.remainingBudget >= 0 ? .green : .red)
        }
    }
} 