import Foundation

struct Statistics {
    let budget: Budget
    let period: DateInterval
    
    var totalSpent: Decimal {
        budget.categories.reduce(into: Decimal(0)) { result, category in
            result += Decimal(category.spent)
        }
    }
    
    var averageDailySpend: Decimal {
        let days = Calendar.current.dateComponents([.day], from: period.start, to: period.end).day ?? 1
        return totalSpent / Decimal(days)
    }
    
    var topCategories: [Category] {
        budget.categories.sorted(by: { (cat1: Category, cat2: Category) in
            cat1.spent > cat2.spent
        })
    }
    
    var projectedOverspend: Decimal? {
        guard let daysInPeriod = Calendar.current.dateComponents([.day], from: period.start, to: period.end).day,
              daysInPeriod > 0 else { return nil }
        
        let daysElapsed = Calendar.current.dateComponents([.day], from: period.start, to: Date()).day ?? 0
        let dailyRate = totalSpent / Decimal(daysElapsed)
        let projectedTotal = dailyRate * Decimal(daysInPeriod)
        
        return projectedTotal - Decimal(budget.totalBudget)
    }
} 