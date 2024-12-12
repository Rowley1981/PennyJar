import SwiftUI

struct CategoryRowView: View {
    let category: Category
    
    var body: some View {
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