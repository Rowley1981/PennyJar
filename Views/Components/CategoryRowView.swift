import SwiftUI

struct CategoryRowView: View {
    let category: Category
    
    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .font(.title3)
                .foregroundStyle(category.color)
                .frame(width: 32, height: 32)
                .background(category.color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(category.name)
                    .font(.headline)
                
                if let notes = category.notes {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            
            Spacer()
            
            if let budget = category.budget {
                Text(category.budgetAmount.formatted(.currency(code: budget.currency.code)))
                    .foregroundStyle(Theme.textPrimary)
            }
        }
        .padding(.vertical, 4)
    }
} 