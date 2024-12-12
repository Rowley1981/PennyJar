import SwiftUI

struct CreateCategoryView: View {
    let budget: Budget
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var budgetAmount = 0.0
    @State private var iconName = "dollarsign.circle.fill"
    @State private var iconColor = Color.blue
    @State private var notes = ""
    @State private var showIconPicker = false
    @State private var recommendedIcons: [String] = []
    
    var body: some View {
        Form {
            Section {
                TextField("Category Name", text: $name)
                    .onChange(of: name) { oldValue, newValue in
                        recommendedIcons = IconRecommendationService.shared.recommendIcons(for: newValue)
                    }
                
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
                
                if !recommendedIcons.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(recommendedIcons, id: \.self) { icon in
                                Button {
                                    iconName = icon
                                } label: {
                                    Image(systemName: icon)
                                        .font(.title2)
                                        .foregroundStyle(iconColor)
                                        .frame(width: 44, height: 44)
                                        .background(iconName == icon ? Color.blue.opacity(0.2) : Color.clear)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                ColorPicker("Icon Color", selection: $iconColor)
            }
            
            Section {
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(3...6)
            }
        }
        .navigationTitle("New Category")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    let category = Category(
                        name: name,
                        budgetAmount: budgetAmount,
                        iconName: iconName,
                        iconColor: iconColor,
                        notes: notes
                    )
                    budget.addCategory(category)
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