import SwiftUI

struct CategoryRow: View {
    let budget: Budget
    let category: Category
    @State private var showDeleteAlert = false
    @State private var showEditSheet = false
    @State private var showTransactions = false
    @State private var showAddTransaction = false
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: category.iconName)
                    .foregroundStyle(category.iconColor)
                    .font(.title2)
                
                Text(category.name)
                    .font(.headline)
                
                Spacer()
                
                Menu {
                    Button {
                        showEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(.secondary)
                }
            }
            
            Button {
                showTransactions.toggle()
            } label: {
                Text("\(category.spentAmount.formatted(.currency(code: budget.currency.code))) of \(category.budgetAmount.formatted(.currency(code: budget.currency.code)))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(category.spentPercentage > 100 ? Color.red : category.iconColor)
                        .frame(width: min(CGFloat(category.spentPercentage) / 100 * geometry.size.width, geometry.size.width), height: 6)
                }
            }
            .frame(height: 6)
            
            HStack {
                Text("\(Int(category.spentPercentage))% spent")
                Spacer()
                Text("\(category.remainingAmount.formatted(.currency(code: budget.currency.code))) remaining")
                    .foregroundStyle(category.remainingAmount >= 0 ? .green : .red)
            }
            .font(.caption)
            
            if showTransactions {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Transactions")
                            .font(.subheadline.bold())
                        Spacer()
                        Button {
                            showAddTransaction = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(Theme.mediumBlue)
                        }
                    }
                    
                    if category.transactions.isEmpty {
                        Text("No transactions")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(category.transactions.sorted { $0.date > $1.date }) { transaction in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    if !transaction.note.isEmpty {
                                        Text(transaction.note)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                Text(transaction.amount.formatted(.currency(code: budget.currency.code)))
                                    .font(.callout.monospacedDigit())
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding(.top)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 5)
        .alert("Delete Category", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                budget.removeCategory(category)
            }
        } message: {
            Text("Are you sure you want to delete this category? This action cannot be undone.")
        }
        .sheet(isPresented: $showEditSheet) {
            NavigationStack {
                EditCategoryView(budget: budget, category: category)
            }
        }
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionView(budget: budget, category: category)
        }
    }
} 