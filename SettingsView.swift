struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                Section("Categories") {
                    NavigationLink("Manage Categories") {
                        CategoryListView()
                    }
                }
                
                Section("Data") {
                    Button("Export Data") {
                        // TODO: Implement export
                    }
                    Button("Import Data") {
                        // TODO: Implement import
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
} 