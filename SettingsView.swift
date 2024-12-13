struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(BudgetStore.self) private var budgetStore
    @Environment(TransactionStore.self) private var transactionStore
    
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
                        exportData()
                    }
                    Button("Import Data") {
                        importData()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    private func exportData() {
        // Create export data structure
        let exportData = ExportData(
            budgets: budgetStore.budgets,
            transactions: transactionStore.transactions
        )
        
        // Convert to JSON
        guard let jsonData = try? JSONEncoder().encode(exportData),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        
        // Share via system share sheet
        let activityVC = UIActivityViewController(
            activityItems: [jsonString],
            applicationActivities: nil
        )
        
        // Present share sheet
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private func importData() {
        // Implementation would involve document picker
        // and JSON parsing
    }
}

struct ExportData: Codable {
    let budgets: [Budget]
    let transactions: [Transaction]
} 