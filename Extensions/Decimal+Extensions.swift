import Foundation

extension Decimal {
    var doubleValue: Double {
        (self as NSDecimalNumber).doubleValue
    }
} 