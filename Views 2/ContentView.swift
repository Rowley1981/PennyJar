import SwiftUI
import Observation

struct ContentView: View {
    let budgetStore: BudgetStore
    @State private var showGetStarted = false
    
    var body: some View {
        NavigationStack {
            if budgetStore.budgets.isEmpty {
                VStack(spacing: 20) {
                    Text("Welcome to PennyJar")
                        .font(.title)
                        .foregroundStyle(Theme.mediumBlue)
                    // ... rest of the code 