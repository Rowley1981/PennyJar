import SwiftUI

struct BudgetDetailView: View {
    let budgetStore: BudgetStore
    let budget: Budget
    @State private var showAddCategory = false
    @State private var showEditBudget = false
    @State private var selectedTimeframe: BudgetTimeframe = .month
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(budget.name)
                            .font(.title2)
                            .foregroundStyle(Theme.textPrimary)
                        Text(budget.frequency.rawValue)
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    Spacer()
                    Menu {
                        Button("Edit Budget", action: { showEditBudget = true })
                        Button("Reset Expenses", role: .destructive, action: resetExpenses)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                    }
                }
                .padding()
                .cardStyle()
                
                // Budget Summary
                VStack(spacing: 12) {
                    HStack {
                        Text("Total Budget")
                        Spacer()
                        Text(budget.totalBudget.formatted(.currency(code: budget.currency.code)))
                            .foregroundStyle(Theme.mediumBlue)
                    }
                    
                    HStack {
                        Text("Total Spent")
                        Spacer()
                        Text(budget.totalSpent.formatted(.currency(code: budget.currency.code)))
                            .foregroundStyle(budget.totalSpent > budget.totalBudget ? Theme.error : Theme.success)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Remaining")
                        Spacer()
                        Text(budget.remaining.formatted(.currency(code: budget.currency.code)))
                            .foregroundStyle(budget.remaining >= 0 ? Theme.success : Theme.error)
                    }
                }
                .padding()
                .cardStyle()
                
                // Categories
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Categories")
                            .font(.headline)
                        Spacer()
                        Button {
                            showAddCategory = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(Theme.mediumBlue)
                        }
                    }
                    
                    if budget.categories.isEmpty {
                        Text("Add categories to start tracking your expenses")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(budget.categories) { category in
                            CategoryRowView(category: category)
                        }
                    }
                }
                .padding()
                .cardStyle()
            }
            .padding()
        }
        .navigationTitle(budget.name)
        .sheet(isPresented: $showAddCategory) {
            NavigationStack {
                AddCategoryView(budget: budget)
            }
        }
        .sheet(isPresented: $showEditBudget) {
            NavigationStack {
                EditBudgetView(budget: budget, budgetStore: budgetStore)
            }
        }
    }
    
    private func resetExpenses() {
        // Add confirmation dialog
        budget.resetExpenses()
    }
} 