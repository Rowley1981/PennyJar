import SwiftUI

@main
struct PennyJarApp: App {
    @State private var budgetStore = Storage.shared.loadBudgetStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView(budgetStore: budgetStore)
        }
    }
} 