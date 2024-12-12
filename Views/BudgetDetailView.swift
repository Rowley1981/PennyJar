import SwiftUI

struct BudgetDetailView: View {
    @Binding var budget: Budget
    @State private var showingEditBudget = false
    @State private var showingAddCategory = false
    
    var body: some View {
        List {
            BudgetSummarySection(budget: budget)
            
            Section("Categories") {
                ForEach(budget.categories) { category in
                    CategoryRowView(category: category)
                }
                
                Button {
                    showingAddCategory = true
                } label: {
                    Label("Add Category", systemImage: "plus")
                }
            }
        }
        .navigationTitle(budget.name)
        .toolbar {
            Button("Edit") {
                showingEditBudget = true
            }
        }
        .sheet(isPresented: $showingEditBudget) {
            NavigationStack {
                EditBudgetView(budget: $budget)
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            NavigationStack {
                AddCategoryView(budget: budget)
            }
        }
    }
}

private struct BudgetSummarySection: View {
    let budget: Budget
    
    var body: some View {
        Section {
            BudgetProgressView(budget: budget)
            BudgetStatsView(budget: budget)
        }
    }
}

private struct BudgetCategoriesSection: View {
    let budget: Budget
    
    var body: some View {
        Section("Categories") {
            ForEach(budget.categories) { category in
                CategoryRowView(category: category)
            }
        }
    }
}
