import SwiftUI
import Observation

struct CreateBudgetView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    let budgetStore: BudgetStore
    @State private var name = ""
    @State private var selectedCurrency: Currency = .common[0]
    @State private var frequency: BudgetFrequency = .monthly
    @State private var date = Date()
    @State private var searchText = ""
    
    private var datePickerComponents: DatePickerComponents {
        switch frequency {
        case .daily:
            return [.date]
        case .weekly:
            return [.date]
        case .monthly:
            return [.date]
        case .yearly:
            return [.date]
        }
    }
    
    // ... rest of the code 