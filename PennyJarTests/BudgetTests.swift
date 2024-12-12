import XCTest
@testable import PennyJar

final class BudgetTests: XCTestCase {
    var budget: Budget!
    
    override func setUp() {
        super.setUp()
        budget = Budget(
            name: "Test Budget",
            currency: Currency(code: "USD", name: "US Dollar", symbol: "$"),
            frequency: .monthly,
            date: Date()
        )
    }
    
    func testAddCategory() throws {
        let category = Category(
            name: "Test Category",
            budgetAmount: 100,
            iconName: "dollarsign.circle",
            iconColor: .blue
        )
        
        XCTAssertNoThrow(try budget.validateCategory(category))
        budget.addCategory(category)
        XCTAssertEqual(budget.categories.count, 1)
        XCTAssertEqual(budget.categories.first?.name, "Test Category")
    }
    
    func testDuplicateCategory() throws {
        let category1 = Category(
            name: "Test Category",
            budgetAmount: 100,
            iconName: "dollarsign.circle",
            iconColor: .blue
        )
        
        let category2 = Category(
            name: "Test Category",
            budgetAmount: 200,
            iconName: "cart.fill",
            iconColor: .green
        )
        
        budget.addCategory(category1)
        XCTAssertThrowsError(try budget.validateCategory(category2)) { error in
            XCTAssertEqual(error as? ValidationError, .invalidCategory)
        }
    }
    
    func testAddPeriod() throws {
        let calendar = Calendar.current
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: budget.date) else {
            XCTFail("Failed to create next month date")
            return
        }
        
        XCTAssertNoThrow(try budget.validateNewPeriod(nextMonth))
        let period = budget.addPeriod(date: nextMonth)
        XCTAssertEqual(budget.periods.count, 1)
        XCTAssertEqual(period.date, nextMonth)
    }
    
    func testInvalidPeriod() throws {
        let calendar = Calendar.current
        guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: budget.date) else {
            XCTFail("Failed to create next week date")
            return
        }
        
        XCTAssertThrowsError(try budget.validateNewPeriod(nextWeek)) { error in
            XCTAssertEqual(error as? ValidationError, .invalidPeriod)
        }
    }
} 