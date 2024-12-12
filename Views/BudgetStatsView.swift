import SwiftUI

struct BudgetStatsView: View {
    let budget: Budget
    private var analytics: BudgetAnalytics {
        BudgetAnalytics(budget: budget)
    }
    
    var body: some View {
        Group {
            LabeledContent("Total Budget") {
                Text(analytics.totalBudget.formatted(.currency(code: budget.currency.code)))
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