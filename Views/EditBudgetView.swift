import SwiftUI

struct EditBudgetView: View {
    @Binding var budget: Budget
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Overall Budget Card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Overall Budget")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chart.pie.fill")
                            .foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "banknote.fill")
                                .foregroundColor(.green)
                            Text("£0.00")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        Text("£0.00 of £0.00")
                            .foregroundColor(.secondary)
                        
                        // Progress Bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(width: geometry.size.width, height: 8)
                                    .foregroundColor(Color(.systemGray6))
                                    .cornerRadius(4)
                                
                                Rectangle()
                                    .frame(width: 0, height: 8)
                                    .foregroundColor(.green)
                                    .cornerRadius(4)
                            }
                        }
                        .frame(height: 8)
                        
                        HStack {
                            Text("0% spent")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("£0.00 remaining")
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // Categories Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Categories")
                            .font(.headline)
                        Spacer()
                        Button {
                            // Add category action
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    
                    if budget.categories.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "folder.badge.plus")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)
                            Text("No Categories")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Add categories to start tracking your spending")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditBudgetView(budget: .constant(Budget(
            name: "Preview Budget",
            currency: .gbp,
            frequency: .monthly,
            date: .now
        )))
    }
} 