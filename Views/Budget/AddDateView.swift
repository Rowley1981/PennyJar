import SwiftUI

struct AddDateView: View {
    let budget: Budget
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate = Date()
    
    var allowedDates: [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        let endDate = calendar.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        
        var currentDate = budget.date
        while currentDate <= endDate {
            let nextDate: Date?
            switch budget.frequency {
            case .weekly:
                nextDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate)
            case .monthly:
                nextDate = calendar.date(byAdding: .month, value: 1, to: currentDate)
            case .yearly:
                nextDate = calendar.date(byAdding: .year, value: 1, to: currentDate)
            }
            
            if let next = nextDate {
                dates.append(next)
                currentDate = next
            }
        }
        return dates
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select Date", selection: $selectedDate) {
                        ForEach(allowedDates, id: \.self) { date in
                            Text(date.formatted(date: .long, time: .omitted))
                                .tag(date)
                        }
                    }
                } footer: {
                    Text("Only future dates matching the budget's \(budget.frequency.rawValue) frequency are available")
                }
            }
            .navigationTitle("Add Budget Period")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        budget.addPeriod(date: selectedDate)
                        dismiss()
                    }
                }
            }
        }
    }
} 