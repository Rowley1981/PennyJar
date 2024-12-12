import SwiftUI

struct DatePickerButton: View {
    let budget: Budget
    @State private var showPeriodPicker = false
    @State private var selectedPeriod: BudgetPeriod?
    
    var sortedPeriods: [BudgetPeriod] {
        budget.periods.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        Menu {
            ForEach(sortedPeriods) { period in
                Button {
                    selectedPeriod = period
                } label: {
                    if period.date == budget.date {
                        Label(
                            period.date.formatted(date: .abbreviated, time: .omitted),
                            systemImage: "checkmark"
                        )
                    } else {
                        Text(period.date.formatted(date: .abbreviated, time: .omitted))
                    }
                }
            }
        } label: {
            HStack {
                Text(budget.date.formatted(date: .abbreviated, time: .omitted))
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
        }
    }
} 