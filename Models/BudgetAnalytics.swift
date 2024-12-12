import Foundation
import SwiftUI

struct CategoryAnalytics {
    let category: Category
    let averageSpent: Double
    let totalSpent: Double
    let frequency: Int
    let trend: Double // Positive means increasing spend, negative means decreasing
}

struct BudgetAnalytics {
    let budget: Budget
    private let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar
    }()
    
    var totalSpent: Double {
        budget.totalSpent
    }
    
    var totalBudget: Double {
        budget.totalBudget
    }
    
    var remainingBudget: Double {
        budget.remaining
    }
    
    var percentageSpent: Double {
        guard totalBudget > 0 else { return 0 }
        return (totalSpent / totalBudget) * 100
    }
    
    var projectedOverspend: Double? {
        let daysInPeriod: Double
        let currentDay: Double
        
        switch budget.frequency {
        case .daily:
            daysInPeriod = 1
            currentDay = 1
        case .weekly:
            daysInPeriod = 7
            currentDay = Double(calendar.component(.weekday, from: budget.date))
        case .monthly:
            daysInPeriod = Double(calendar.range(of: .day, in: .month, for: budget.date)?.count ?? 30)
            currentDay = Double(calendar.component(.day, from: budget.date))
        case .yearly:
            daysInPeriod = Double(calendar.range(of: .day, in: .year, for: budget.date)?.count ?? 365)
            currentDay = Double(calendar.ordinality(of: .day, in: .year, for: budget.date) ?? 1)
        }
        
        guard currentDay > 0, daysInPeriod > 0 else { return nil }
        
        let dailyRate = totalSpent / currentDay
        let projectedTotal = dailyRate * daysInPeriod
        
        return projectedTotal - totalBudget
    }
}

struct BudgetAnalyticsPreview: PreviewProvider {
    static var previews: some View {
        let budget = Budget(
            name: "Monthly Budget",
            currency: Currency(code: "USD", name: "US Dollar", symbol: "$"),
            frequency: .monthly,
            date: Date()
        )
        
        let foodCategory = Category(
            name: "Food",
            budget: budget,
            budgetAmount: 500,
            icon: "cart.fill",
            color: .green
        )
        
        let rentCategory = Category(
            name: "Rent",
            budget: budget,
            budgetAmount: 1500,
            icon: "house.fill",
            color: .blue
        )
        
        let transportCategory = Category(
            name: "Transport",
            budget: budget,
            budgetAmount: 200,
            icon: "car.fill",
            color: .orange
        )
        
        budget.addCategory(foodCategory)
        budget.addCategory(rentCategory)
        budget.addCategory(transportCategory)
        
        return BudgetReportView(budget: budget)
    }
} 