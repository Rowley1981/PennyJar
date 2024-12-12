import SwiftUI

struct CategoryListView: View {
    let budget: Budget
    @State private var showingAddCategory = false
    @State private var searchText = ""
    
    var filteredCategories: [Category] {
        if searchText.isEmpty {
            return budget.categories
        }
        return budget.categories.filter { category in
            category.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredCategories) { category in
                NavigationLink(value: category) {
                    CategoryRowView(category: category)
                }
            }
            .onDelete(perform: deleteCategories)
        }
        .searchable(text: $searchText, prompt: "Search categories")
        .navigationTitle("Categories")
        .navigationDestination(for: Category.self) { category in
            CategoryDetailView(category: category)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddCategory = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddCategory) {
            NavigationStack {
                AddCategoryView(budget: budget)
            }
        }
    }
    
    private func deleteCategories(at offsets: IndexSet) {
        offsets.forEach { index in
            let category = filteredCategories[index]
            budget.removeCategory(category)
        }
    }
} 