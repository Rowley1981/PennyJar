import SwiftUI

struct TotalSpentRowView: View {
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