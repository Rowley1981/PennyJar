import SwiftUI

struct ContentView: View {
    @State private var budgetStore = BudgetStore()
    
    var body: some View {
        TabView {
            NavigationStack {
                BudgetListView(budgetStore: budgetStore)
            }
            .tabItem {
                Label("Budgets", systemImage: "dollarsign.circle")
            }
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview("Empty State") {
    ContentView()
}

#Preview("With Budgets") {
    let store = BudgetStore()
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
    
    let transportCategory = Category(
        name: "Transport",
        budget: budget,
        budgetAmount: 200,
        icon: "car.fill",
        color: .blue
    )
    
    budget.addCategory(foodCategory)
    budget.addCategory(transportCategory)
    store.addBudget(budget)
    
    return ContentView()
}
