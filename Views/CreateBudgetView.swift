import SwiftUI

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
    
    var body: some View {
        // Implementation needed here
        Form {
            Section {
                TextField("Budget Name", text: $name)
                Picker("Currency", selection: $selectedCurrency) {
                    ForEach(Currency.common) { currency in
                        Text(currency.code).tag(currency)
                    }
                }
                Picker("Frequency", selection: $frequency) {
                    ForEach(BudgetFrequency.allCases, id: \.self) { frequency in
                        Text(frequency.rawValue).tag(frequency)
                    }
                }
                DatePicker("Start Date", selection: $date, displayedComponents: datePickerComponents)
            }
        }
        .navigationTitle("New Budget")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let budget = Budget(name: name, 
                                      currency: selectedCurrency,
                                      frequency: frequency,
                                      date: date)
                    budgetStore.addBudget(budget)
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
    }
}
