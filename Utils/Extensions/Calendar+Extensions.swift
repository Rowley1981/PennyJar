import Foundation

extension Calendar {
    // Helper methods for date calculations
    private func start(of component: Calendar.Component, for date: Date) -> Date {
        let components = self.dateComponents([.year, .month, .day], from: date)
        switch component {
        case .day:
            return self.date(from: components) ?? date
        case .weekOfYear:
            var comp = components
            comp.day = comp.day! - (self.component(.weekday, from: date) - 1)
            return self.date(from: comp) ?? date
        case .month:
            var comp = components
            comp.day = 1
            return self.date(from: comp) ?? date
        case .year:
            var comp = components
            comp.day = 1
            comp.month = 1
            return self.date(from: comp) ?? date
        default:
            return date
        }
    }
    
    private func end(of component: Calendar.Component, for date: Date) -> Date {
        let start = self.start(of: component, for: date)
        var components = DateComponents()
        switch component {
        case .day:
            components.day = 1
        case .weekOfYear:
            components.day = 7
        case .month:
            components.month = 1
        case .year:
            components.year = 1
        default:
            break
        }
        components.second = -1
        return self.date(byAdding: components, to: start) ?? date
    }
    
    // Public interface
    func startOfDay(for date: Date) -> Date {
        return start(of: .day, for: date)
    }
    
    func endOfDay(for date: Date) -> Date {
        return end(of: .day, for: date)
    }
    
    func startOfWeek(for date: Date) -> Date {
        return start(of: .weekOfYear, for: date)
    }
    
    func endOfWeek(for date: Date) -> Date {
        return end(of: .weekOfYear, for: date)
    }
    
    func startOfMonth(for date: Date) -> Date {
        return start(of: .month, for: date)
    }
    
    func endOfMonth(for date: Date) -> Date {
        return end(of: .month, for: date)
    }
    
    func startOfYear(for date: Date) -> Date {
        return start(of: .year, for: date)
    }
    
    func endOfYear(for date: Date) -> Date {
        return end(of: .year, for: date)
    }
    
    // Budget specific methods
    func numberOfDaysInPeriod(for budget: Budget) -> Int {
        switch budget.frequency {
        case .daily:
            return 1
        case .weekly:
            return 7
        case .monthly:
            let range = range(of: .day, in: .month, for: budget.date)
            return range?.count ?? 30
        case .yearly:
            return isLeapYear(budget.date) ? 366 : 365
        }
    }
    
    func dayInPeriod(for budget: Budget) -> Int {
        switch budget.frequency {
        case .daily:
            return 1
        case .weekly:
            let weekday = component(.weekday, from: budget.date)
            return weekday
        case .monthly:
            let day = component(.day, from: budget.date)
            return day
        case .yearly:
            let dayOfYear = ordinality(of: .day, in: .year, for: budget.date)
            return dayOfYear ?? 1
        }
    }
    
    private func isLeapYear(_ date: Date) -> Bool {
        let year = component(.year, from: date)
        return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
    }
} 