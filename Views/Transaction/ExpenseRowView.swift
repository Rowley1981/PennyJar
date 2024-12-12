import SwiftUI

struct ExpenseRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            if let category = transaction.category {
                Image(systemName: category.icon)
                    .font(.title3)
                    .foregroundStyle(category.color)
                    .frame(width: 32, height: 32)
                    .background(category.color.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(transaction.note)
                        .font(.headline)
                    
                    Text(category.name)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
                
                Spacer()
                
                if let budget = category.budget {
                    VStack(alignment: .trailing) {
                        Text(transaction.amount.formatted(.currency(code: budget.currency.code)))
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
} 