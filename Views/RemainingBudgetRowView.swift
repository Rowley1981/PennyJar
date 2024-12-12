import SwiftUI

struct RemainingBudgetRowView: View {
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