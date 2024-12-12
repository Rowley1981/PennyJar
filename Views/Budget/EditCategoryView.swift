import SwiftUI

struct EditCategoryView: View {
    let budget: Budget
    let category: Category
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var budgetAmount: Double
    @State private var iconName: String
    @State private var iconColor: Color
    @State private var notes: String
    @State private var showIconPicker = false
    
    init(budget: Budget, category: Category) {
        self.budget = budget
        self.category = category
        _name = State(initialValue: category.name)
        _budgetAmount = State(initialValue: category.budgetAmount)
        _iconName = State(initialValue: category.iconName)
        _iconColor = State(initialValue: category.iconColor)
        _notes = State(initialValue: category.notes)
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Category Name", text: $name)
                
                HStack {
                    Text(budget.currency.symbol)
                    TextField("Budget Amount", value: $budgetAmount, format: .number)
                        .keyboardType(.decimalPad)
                }
            }
            
            Section {
                HStack {
                    Image(systemName: iconName)
                        .foregroundStyle(iconColor)
                        .font(.title2)
                    
                    Spacer()
                    
                    Button("Choose Icon") {
                        showIconPicker = true
                    }
                }
                
                ColorPicker("Icon Color", selection: $iconColor)
            }
            
            Section {
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(3...6)
            }
        }
        .navigationTitle("Edit Category")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let updatedCategory = Category(
                        id: category.id,
                        name: name,
                        budgetAmount: budgetAmount,
                        spentAmount: category.spentAmount,
                        iconName: iconName,
                        iconColor: iconColor,
                        notes: notes
                    )
                    budget.updateCategory(updatedCategory)
                    dismiss()
                }
                .disabled(name.isEmpty || budgetAmount <= 0)
            }
        }
        .sheet(isPresented: $showIconPicker) {
            IconPickerView(selectedIcon: $iconName)
        }
    }
} 