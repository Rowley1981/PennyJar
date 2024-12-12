import SwiftUI

struct TransactionListView: View {
    let budgetStore: BudgetStore
    @State private var searchText = ""
    @State private var selectedBudget: Budget?
    @State private var selectedCategory: Category?
    
    var transactions: [Transaction] {
        let allTransactions = budgetStore.budgets.flatMap { budget in
            budget.categories.flatMap { category in
                category.transactions.map { transaction in
                    transaction
                }
            }
        }
        
        return allTransactions
            .filter { transaction in
                if let selectedBudget = selectedBudget {
                    guard transaction.category?.budget?.id == selectedBudget.id else { return false }
                }
                if let selectedCategory = selectedCategory {
                    guard transaction.category?.id == selectedCategory.id else { return false }
                }
                if !searchText.isEmpty {
                    guard transaction.note.localizedCaseInsensitiveContains(searchText) else { return false }
                }
                return true
            }
            .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        List {
            if transactions.isEmpty {
                ContentUnavailableView(
                    "No Expenses",
                    systemImage: "list.bullet",
                    description: Text("Add expenses to your categories to see them here")
                )
            } else {
                ForEach(transactions) { transaction in
                    TransactionRowView(transaction: transaction)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search expenses")
        .navigationTitle("Expenses")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Menu("Budget") {
                        Button("All", action: { selectedBudget = nil })
                        ForEach(budgetStore.budgets) { budget in
                            Button(budget.name) {
                                selectedBudget = budget
                                if let selectedCategory = selectedCategory,
                                   selectedCategory.budget?.id != budget.id {
                                    self.selectedCategory = nil
                                }
                            }
                        }
                    }
                    
                    Menu("Category") {
                        Button("All", action: { selectedCategory = nil })
                        if let selectedBudget = selectedBudget {
                            ForEach(selectedBudget.categories) { category in
                                Button(category.name) {
                                    selectedCategory = category
                                }
                            }
                        } else {
                            ForEach(budgetStore.budgets) { budget in
                                ForEach(budget.categories) { category in
                                    Button(category.name) {
                                        selectedCategory = category
                                        selectedBudget = budget
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
    }
}

#Preview {
    let budget = Budget(name: "December 2024", currency: .gbp, frequency: .monthly, date: .now)
    let budgetStore = BudgetStore()
    budgetStore.budgets = [budget]
    
    return NavigationStack {
        TransactionListView(budgetStore: budgetStore)
    }
} 