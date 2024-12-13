import SwiftUI

@main
struct PennyJarApp: App {
    @State private var budgetStore: BudgetStore
    @State private var transactionStore: TransactionStore
    @State private var showError = false
    @State private var errorMessage = ""
    
    init() {
        do {
            _budgetStore = State(initialValue: BudgetStore())
            _transactionStore = State(initialValue: TransactionStore())
        } catch {
            print("Error initializing stores: \(error.localizedDescription)")
            // Fall back to empty stores
            _budgetStore = State(initialValue: BudgetStore())
            _transactionStore = State(initialValue: TransactionStore())
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(budgetStore)
                .environment(transactionStore)
                .alert("Error", isPresented: $showError) {
                    Button("OK") { }
                } message: {
                    Text(errorMessage)
                }
        }
    }
} 