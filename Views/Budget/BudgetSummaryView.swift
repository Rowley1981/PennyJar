import SwiftUI

struct BudgetSummaryView: View {
    let budget: Budget
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(budget.name)
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                Text(budget.frequency.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Budget")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                    Text(budget.totalBudget.formatted(.currency(code: budget.currency.code)))
                        .foregroundStyle(Theme.mediumBlue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Remaining")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                    Text(budget.remaining.formatted(.currency(code: budget.currency.code)))
                        .foregroundStyle(budget.remaining >= 0 ? Theme.success : Theme.error)
                }
            }
            
            ProgressBar(
                value: min(budget.totalSpent / budget.totalBudget, 1),
                color: budget.remaining >= 0 ? Theme.success : Theme.error
            )
            .frame(height: 4)
        }
    }
} 