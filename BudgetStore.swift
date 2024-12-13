@Observable final class BudgetStore {
    private(set) var budgets: [Budget] = []
    private let savePath = URL.documentsDirectory.appending(path: "budgets.json")
    
    init() {
        loadBudgets()
    }
    
    func addBudget(_ budget: Budget) {
        budgets.append(budget)
        saveBudgets()
    }
    
    func updateBudget(_ budget: Budget, name: String, amount: Double, category: Category) {
        guard let index = budgets.firstIndex(where: { $0.id == budget.id }) else { return }
        budgets[index].name = name
        budgets[index].amount = amount
        budgets[index].category = category
        saveBudgets()
    }
    
    func deleteBudget(_ budget: Budget) {
        budgets.removeAll { $0.id == budget.id }
        saveBudgets()
    }
    
    func updateBudgetSpending(_ budgetId: UUID, amount: Double) {
        guard let index = budgets.firstIndex(where: { $0.id == budgetId }) else { return }
        budgets[index].spent += amount
        budgets[index].remaining = budgets[index].amount - budgets[index].spent
        saveBudgets()
    }
    
    func resetBudgetSpending(_ budget: Budget) {
        guard let index = budgets.firstIndex(where: { $0.id == budget.id }) else { return }
        budgets[index].spent = 0
        budgets[index].remaining = budgets[index].amount
        saveBudgets()
    }
    
    private func saveBudgets() {
        do {
            let data = try JSONEncoder().encode(budgets)
            try data.write(to: savePath)
        } catch {
            print("Error saving budgets: \(error.localizedDescription)")
        }
    }
    
    private func loadBudgets() {
        do {
            let data = try Data(contentsOf: savePath)
            budgets = try JSONDecoder().decode([Budget].self, from: data)
        } catch {
            budgets = []
        }
    }
} 