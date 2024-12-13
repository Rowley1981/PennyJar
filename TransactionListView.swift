struct TransactionListView: View {
    let transactions: [Transaction]
    
    var body: some View {
        if transactions.isEmpty {
            ContentUnavailableView("No Transactions", 
                systemImage: "creditcard",
                description: Text("Add a transaction to get started"))
        } else {
            List(transactions) { transaction in
                NavigationLink(value: transaction) {
                    TransactionRowView(transaction: transaction)
                }
            }
            .navigationDestination(for: Transaction.self) { transaction in
                TransactionDetailView(transaction: transaction)
            }
        }
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.name)
                Text(transaction.date, format: .dateTime)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(transaction.amount, format: .currency(code: "USD"))
                .foregroundStyle(transaction.amount < 0 ? .red : .green)
        }
    }
} 