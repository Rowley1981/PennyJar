@Observable final class TransactionStore {
    private(set) var transactions: [Transaction] = []
    private let savePath = URL.documentsDirectory.appending(path: "transactions.json")
    @Environment(BudgetStore.self) private var budgetStore
    
    var recentTransactions: [Transaction] {
        transactions.sorted { $0.date > $1.date }.prefix(5).map { $0 }
    }
    
    init() {
        loadTransactions()
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        updateBudgetSpending(for: transaction)
        saveTransactions()
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
        saveTransactions()
    }
    
    private func updateBudgetSpending(for transaction: Transaction) {
        guard let budgetId = transaction.budgetId,
              let index = budgetStore.budgets.firstIndex(where: { $0.id == budgetId }) else { return }
        
        budgetStore.budgets[index].spent += transaction.amount
        budgetStore.budgets[index].remaining = budgetStore.budgets[index].amount - budgetStore.budgets[index].spent
        
        // Save budget changes
        budgetStore.saveBudgets()
    }
    
    private func saveTransactions() {
        do {
            let data = try JSONEncoder().encode(transactions)
            try data.write(to: savePath)
        } catch {
            print("Error saving transactions: \(error.localizedDescription)")
        }
    }
    
    private func loadTransactions() {
        do {
            let data = try Data(contentsOf: savePath)
            transactions = try JSONDecoder().decode([Transaction].self, from: data)
        } catch {
            transactions = []
        }
    }
} 