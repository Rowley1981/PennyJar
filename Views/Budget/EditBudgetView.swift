import SwiftUI

struct EditBudgetView: View {
    @Binding var budget: Budget
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var currency: Currency
    @State private var frequency: BudgetFrequency
    @State private var date: Date
    
    init(budget: Binding<Budget>) {
        _budget = budget
        _name = State(initialValue: budget.wrappedValue.name)
        _currency = State(initialValue: budget.wrappedValue.currency)
        _frequency = State(initialValue: budget.wrappedValue.frequency)
        _date = State(initialValue: budget.wrappedValue.date)
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Budget Name", text: $name)
                
                Picker("Currency", selection: $currency) {
                    ForEach(Currency.allCases) { currency in
                        Text("\(currency.symbol) \(currency.name)")
                            .tag(currency)
                    }
                }
                
                Picker("Frequency", selection: $frequency) {
                    ForEach(BudgetFrequency.allCases) { frequency in
                        Text(frequency.rawValue)
                            .tag(frequency)
                    }
                }
                
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
            }
        }
        .navigationTitle("Edit Budget")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    updateBudget()
                }
                .disabled(name.isEmpty)
            }
        }
    }
    
    private func updateBudget() {
        budget.name = name
        budget.currency = currency
        budget.frequency = frequency
        budget.date = date
        dismiss()
    }
}

#Preview {
    let budget = Budget(
        name: "Monthly Budget",
        currency: Currency(code: "USD", name: "US Dollar", symbol: "$"),
        frequency: .monthly,
        date: Date()
    )
    
    return NavigationStack {
        EditBudgetView(budget: .constant(budget))
    }
} 