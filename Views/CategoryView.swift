import SwiftUI

struct CategoryView: View {
    let category: Category
    
    private var percentageSpent: Double {
        guard category.budgetAmount > 0 else { return 0 }
        return (category.spent / category.budgetAmount) * 100
    }
    
    var body: some View {
        VStack {
            CircularProgressView(
                value: percentageSpent / 100.0,
                color: category.color
            )
            // ... rest of the view
        }
    }
} 