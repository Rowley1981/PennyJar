import SwiftUI

struct BudgetListView: View {
    @Bindable var budgetStore: BudgetStore
    @State private var searchText = ""
    @State private var showCreateBudget = false
    
    var filteredBudgets: [Budget] {
        if searchText.isEmpty {
            return budgetStore.budgets
        }
        return budgetStore.budgets.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ZStack {
            if budgetStore.budgets.isEmpty {
                EmptyBudgetView(showCreateBudget: $showCreateBudget)
            } else {
                List {
                    ForEach(filteredBudgets) { budget in
                        let index = budgetStore.budgets.firstIndex(where: { $0.id == budget.id })!
                        NavigationLink {
                            BudgetDetailView(budget: $budgetStore.budgets[index])
                        } label: {
                            BudgetSummaryView(budget: budget)
                        }
                    }
                    .onDelete(perform: deleteBudgets)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search budgets")
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
    
    private func deleteBudgets(at offsets: IndexSet) {
        for index in offsets {
            budgetStore.deleteBudget(filteredBudgets[index])
        }
    }
}

private struct EmptyBudgetView: View {
    @Binding var showCreateBudget: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "dollarsign.circle")
                .font(.system(size: 60))
                .foregroundStyle(Theme.mediumBlue)
            
            Text("Welcome to PennyJar")
                .font(.title)
                .foregroundStyle(Theme.textPrimary)
            
            Text("Create your first budget to get started")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
            
            Button {
                showCreateBudget = true
            } label: {
                Text("Create Budget")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.mediumBlue)
            .padding(.top)
        }
        .padding()
    }
} 