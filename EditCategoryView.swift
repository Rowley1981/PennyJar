struct EditCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(CategoryStore.self) private var categoryStore
    
    let category: CategoryStore.CustomCategory
    @State private var name: String
    @State private var selectedIcon: String
    @State private var suggestedIcons: [String] = []
    @State private var showError = false
    @State private var errorMessage = ""
    
    init(category: CategoryStore.CustomCategory) {
        self.category = category
        _name = State(initialValue: category.name)
        _selectedIcon = State(initialValue: category.icon)
    }
    
    private func updateSuggestedIcons() {
        // Same icon suggestion logic as AddCategoryView
        let commonIcons = [
            "house": ["house", "house.fill", "building"],
            "food": ["fork.knife", "cup.and.saucer", "cart"],
            "transport": ["car", "bus", "airplane"],
            "health": ["heart", "cross.case", "pills"],
            "entertainment": ["tv", "gamecontroller", "movie"],
            "shopping": ["bag", "cart", "creditcard"],
            "utilities": ["bolt", "wifi", "phone"],
            "education": ["book", "graduationcap", "pencil"],
        ]
        
        let lowercasedName = name.lowercased()
        suggestedIcons = commonIcons.filter { key, _ in
            lowercasedName.contains(key)
        }.flatMap { $0.value }
        
        if suggestedIcons.isEmpty {
            suggestedIcons = ["tag", "folder", "circle", "square", "star"]
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Category Name", text: $name)
                    .onChange(of: name) { _ in
                        updateSuggestedIcons()
                    }
                
                Section("Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
                        ForEach(suggestedIcons, id: \.self) { iconName in
                            Image(systemName: iconName)
                                .font(.title2)
                                .frame(width: 44, height: 44)
                                .background(selectedIcon == iconName ? Color.accentColor : Color.clear)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedIcon = iconName
                                }
                        }
                    }
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
                        do {
                            try categoryStore.updateCategory(category, name: name, icon: selectedIcon)
                            dismiss()
                        } catch CategoryStore.CategoryError.duplicateName {
                            errorMessage = "A category with this name already exists"
                            showError = true
                        } catch {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
} 