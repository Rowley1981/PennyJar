#Preview {
    NavigationStack {
        BudgetSelectionView(selection: .constant(Budget(
            name: "December 2024",
            currency: .gbp,
            frequency: .monthly,
            date: .now
        )))
    }
} 