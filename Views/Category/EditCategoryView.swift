import SwiftUI

struct EditCategoryView: View {
    let category: Category
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var budgetAmount: Double
    @State private var selectedIcon: String
    @State private var selectedColor: Color
    @State private var notes: String
    @State private var showIconPicker = false
    
    init(category: Category) {
        self.category = category
        _name = State(initialValue: category.name)
        _budgetAmount = State(initialValue: category.budgetAmount)
        _selectedIcon = State(initialValue: category.icon)
        _selectedColor = State(initialValue: category.color)
        _notes = State(initialValue: category.notes ?? "")
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Category Name", text: $name)
                
                HStack {
                    Text(category.budget?.currency.symbol ?? "$")
                    TextField("Budget Amount", value: $budgetAmount, format: .number)
                        .keyboardType(.decimalPad)
                }
                
                Button {
                    showIconPicker = true
                } label: {
                    HStack {
                        Text("Icon")
                        Spacer()
                        Image(systemName: selectedIcon)
                            .foregroundStyle(selectedColor)
                    }
                }
                
                ColorPicker("Color", selection: $selectedColor)
                
                TextField("Notes (Optional)", text: $notes, axis: .vertical)
                    .lineLimit(3...6)
            }
        }
        .navigationTitle("Edit Category")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    updateCategory()
                }
                .disabled(name.isEmpty || budgetAmount <= 0)
            }
        }
        .sheet(isPresented: $showIconPicker) {
            NavigationStack {
                IconPickerView(selectedIcon: $selectedIcon)
            }
        }
    }
    
    private func updateCategory() {
        category.name = name
        category.budgetAmount = budgetAmount
        category.icon = selectedIcon
        category.color = selectedColor
        category.notes = notes.isEmpty ? nil : notes
        dismiss()
    }
} 