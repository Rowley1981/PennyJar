struct CategoryListView: View {
    @Environment(BudgetStore.self) private var budgetStore
    @Environment(CategoryStore.self) private var categoryStore
    @State private var showingAddCategory = false
    @State private var categoryToEdit: CategoryStore.CustomCategory?
    @State private var categoryToDelete: CategoryStore.CustomCategory?
    @State private var showError = false
    @State private var errorMessage = ""
    
    var categorySummaries: [(Category, CategorySummary)] {
        Category.allCases.map { category in
            let budgets = budgetStore.budgets.filter { $0.category == category }
            let summary = CategorySummary(
                totalBudget: budgets.reduce(0) { $0 + $1.amount },
                totalSpent: budgets.reduce(0) { $0 + $1.spent }
            )
            return (category, summary)
        }
    }
    
    var body: some View {
        List {
            // Built-in categories
            Section {
                ForEach(categorySummaries, id: \.0) { category, summary in
                    NavigationLink(value: category) {
                        CategoryRowView(category: category, summary: summary)
                    }
                }
            }
            
            // Custom categories
            if !categoryStore.customCategories.isEmpty {
                Section("Custom Categories") {
                    ForEach(categoryStore.customCategories) { category in
                        HStack {
                            Image(systemName: category.icon)
                                .font(.title3)
                            Text(category.name)
                            
                            Spacer()
                            
                            Menu {
                                Button("Edit") {
                                    categoryToEdit = category
                                }
                                Button("Delete", role: .destructive) {
                                    categoryToDelete = category
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onMove { source, destination in
                        categoryStore.moveCategory(from: source, to: destination)
                    }
                }
            }
        }
        .navigationTitle("Categories")
        .navigationDestination(for: Category.self) { category in
            CategoryDetailView(category: category)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    showingAddCategory = true
                }
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView()
        }
        .sheet(item: $categoryToEdit) { category in
            EditCategoryView(category: category)
        }
        .alert("Delete Category?", isPresented: .init(
            get: { categoryToDelete != nil },
            set: { if !$0 { categoryToDelete = nil } }
        )) {
            Button("Delete", role: .destructive) {
                if let category = categoryToDelete {
                    categoryStore.deleteCategory(category)
                }
                categoryToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                categoryToDelete = nil
            }
        } message: {
            if let category = categoryToDelete {
                Text("Are you sure you want to delete '\(category.name)'? This cannot be undone.")
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
}

struct CategoryRowView: View {
    let category: Category
    let summary: CategorySummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: category.icon)
                    .font(.title3)
                Text(category.rawValue)
                    .font(.headline)
                Spacer()
                Text(summary.totalBudget, format: .currency(code: "USD"))
            }
            
            ProgressView(value: summary.totalSpent, total: summary.totalBudget)
                .tint(summary.totalSpent > summary.totalBudget ? .red : .green)
            
            HStack {
                Text("Spent: \(summary.totalSpent, format: .currency(code: "USD"))")
                Spacer()
                Text("Remaining: \(summary.remaining, format: .currency(code: "USD"))")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
}

struct CategorySummary {
    let totalBudget: Double
    let totalSpent: Double
    
    var remaining: Double {
        totalBudget - totalSpent
    }
} 