import SwiftUI

struct BudgetSelectionView: View {
    let budgetStore: BudgetStore
    @State private var showCreateBudget = false
    
    var body: some View {
        List {
            ForEach(budgetStore.budgets) { budget in
                BudgetRowView(budget: budget)
            }
        }
        .navigationTitle("Budgets")
        .toolbar {
            Button {
                showCreateBudget = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showCreateBudget) {
            NavigationStack {
                CreateBudgetView(budgetStore: budgetStore)
            }
        }
    }
}

struct BudgetRowView: View {
    let budget: Budget
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(budget.name)
                .font(.headline)
            Text("\(budget.currency.symbol)\(budget.totalBudget)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}