import SwiftUI

struct EditCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var category: Category
    
    @State private var name: String
    @State private var budgetAmount: Double
    @State private var icon: String
    @State private var color: Color
    @State private var notes: String
    
    init(category: Binding<Category>) {
        _category = category
        _name = State(initialValue: category.wrappedValue.name)
        _icon = State(initialValue: category.wrappedValue.icon)
        _color = State(initialValue: category.wrappedValue.color)
        _budgetAmount = State(initialValue: category.wrappedValue.budgetAmount)
        _notes = State(initialValue: category.wrappedValue.notes ?? "")
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Budget Amount", value: $budgetAmount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            
            Section("Icon") {
                IconPicker(selectedIcon: $icon)
                ColorPicker("Color", selection: $color)
            }
            
            Section("Notes") {
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
            }
        }
        .navigationTitle("Edit Category")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    category.name = name
                    category.budgetAmount = budgetAmount
                    category.icon = icon
                    category.color = color
                    category.notes = notes
                    dismiss()
                }
                .disabled(name.isEmpty || budgetAmount <= 0)
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
    }
}

struct IconPicker: View {
    @Binding var selectedIcon: String
    
    private let icons = [
        "cart.fill",
        "house.fill",
        "car.fill",
        "airplane",
        "heart.fill",
        "fork.knife",
        "gift.fill",
        "creditcard.fill",
        "medical.thermometer.fill",
        "gamecontroller.fill"
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(icons, id: \.self) { icon in
                    Image(systemName: icon)
                        .font(.title2)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(selectedIcon == icon ? .blue.opacity(0.2) : .clear)
                        )
                        .onTapGesture {
                            selectedIcon = icon
                        }
                }
            }
            .padding(.horizontal)
        }
    }
} 