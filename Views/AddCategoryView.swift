import SwiftUI

struct AddCategoryView: View {
    let budget: Budget
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var budgetAmount = 0.0
    @State private var selectedIcon = "cart.fill"
    @State private var selectedColor = Color.blue
    @State private var notes = ""
    @State private var showIconPicker = false
    
    var body: some View {
        Form {
            Section {
                TextField("Category Name", text: $name)
                
                HStack {
                    Text(budget.currency.symbol)
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
        .navigationTitle("Add Category")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    createCategory()
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
    
    private func createCategory() {
        let category = Category(
            name: name,
            budget: budget,
            budgetAmount: budgetAmount,
            icon: selectedIcon,
            color: selectedColor,
            notes: notes.isEmpty ? nil : notes
        )
        budget.addCategory(category)
        dismiss()
    }
} 