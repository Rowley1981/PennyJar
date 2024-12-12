import SwiftUI

struct CreateBudgetView: View {
    let budgetStore: BudgetStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedCurrency = Currency.usd
    @State private var selectedFrequency = BudgetFrequency.monthly
    @State private var selectedDate = Date()
    
    var body: some View {
        Form {
            Section {
                TextField("Budget Name", text: $name)
                
                Picker("Currency", selection: $selectedCurrency) {
                    ForEach(Currency.allCases) { currency in
                        Text("\(currency.symbol) \(currency.name)")
                            .tag(currency)
                    }
                }
                
                Picker("Frequency", selection: $selectedFrequency) {
                    ForEach(BudgetFrequency.allCases, id: \.self) { frequency in
                        Text(frequency.rawValue)
                            .tag(frequency)
                    }
                }
                
                DatePicker(
                    "Start Date",
                    selection: $selectedDate,
                    displayedComponents: selectedFrequency == .daily ? [.date] : [.date, .hourAndMinute]
                )
            }
        }
        .navigationTitle("Create Budget")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Create") {
                    createBudget()
                }
                .disabled(name.isEmpty)
            }
        }
    }
    
    private func createBudget() {
        let budget = Budget(
            name: name,
            currency: selectedCurrency,
            frequency: selectedFrequency,
            date: selectedDate
        )
        budgetStore.addBudget(budget)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        CreateBudgetView(budgetStore: BudgetStore())
    }
} 