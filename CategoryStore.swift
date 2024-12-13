@Observable final class CategoryStore {
    private(set) var customCategories: [CustomCategory] = []
    private let savePath = URL.documentsDirectory.appending(path: "categories.json")
    
    struct CustomCategory: Identifiable, Codable {
        let id: UUID
        var name: String
        var icon: String
        
        init(id: UUID = UUID(), name: String, icon: String) {
            self.id = id
            self.name = name
            self.icon = icon
        }
    }
    
    init() {
        loadCategories()
    }
    
    enum CategoryError: LocalizedError {
        case duplicateName
        
        var errorDescription: String? {
            switch self {
            case .duplicateName:
                return "A category with this name already exists"
            }
        }
    }
    
    func addCategory(name: String, icon: String) throws {
        // Check for duplicate names (case-insensitive)
        let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let exists = customCategories.contains { $0.name.lowercased() == normalizedName }
        
        if exists {
            throw CategoryError.duplicateName
        }
        
        let category = CustomCategory(name: name, icon: icon)
        customCategories.append(category)
        saveCategories()
    }
    
    func deleteCategory(_ category: CustomCategory) {
        customCategories.removeAll { $0.id == category.id }
        saveCategories()
    }
    
    func updateCategory(_ category: CustomCategory, name: String, icon: String) throws {
        let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let exists = customCategories.contains { 
            $0.id != category.id && $0.name.lowercased() == normalizedName 
        }
        
        if exists {
            throw CategoryError.duplicateName
        }
        
        guard let index = customCategories.firstIndex(where: { $0.id == category.id }) else { return }
        customCategories[index].name = name
        customCategories[index].icon = icon
        saveCategories()
    }
    
    func moveCategory(from source: IndexSet, to destination: Int) {
        customCategories.move(fromOffsets: source, toOffset: destination)
        saveCategories()
    }
    
    private func saveCategories() {
        do {
            let data = try JSONEncoder().encode(customCategories)
            try data.write(to: savePath)
        } catch {
            print("Error saving categories: \(error.localizedDescription)")
        }
    }
    
    private func loadCategories() {
        do {
            let data = try Data(contentsOf: savePath)
            customCategories = try JSONDecoder().decode([CustomCategory].self, from: data)
        } catch {
            customCategories = []
        }
    }
} 