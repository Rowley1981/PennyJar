import SwiftUI

struct CreateBudgetView: View {
    let budgetStore: BudgetStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedCurrency = Currency.gbp
    @State private var selectedFrequency = BudgetFrequency.monthly
    @State private var selectedDate = Date().startOfMonth() // Default to start of current month
    @State private var showMonthPicker = false
    @State private var showYearPicker = false
    @State private var showingSuccessAlert = false
    
    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let start = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        let end = calendar.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        return start...end
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        switch selectedFrequency {
        case .daily:
            formatter.dateFormat = "dd MMM yyyy"
        case .weekly:
            formatter.dateFormat = "dd MMM yyyy"
        case .monthly:
            formatter.dateFormat = "MMMM yyyy"
        case .yearly:
            formatter.dateFormat = "yyyy"
        }
        return formatter
    }
    
    private func adjustDate() {
        switch selectedFrequency {
        case .daily:
            // Keep the exact date
            break
        case .weekly:
            // Adjust to the next Sunday
            selectedDate = selectedDate.nextWeekend()
        case .monthly:
            // Adjust to start of month
            selectedDate = selectedDate.startOfMonth()
        case .yearly:
            // Adjust to start of year
            selectedDate = selectedDate.startOfYear()
        }
    }
    
    private let weeklyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yy"
        return formatter
    }()
    
    private var dateSelectionView: some View {
        Group {
            switch selectedFrequency {
            case .daily:
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: dateRange,
                    displayedComponents: [.date]
                )
                
            case .weekly:
                VStack(alignment: .leading, spacing: 4) {
                    Text("Budget - Week Ending \(weeklyDateFormatter.string(from: selectedDate))")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(Color.blue)
                    
                    WeeklyDatePicker(selection: $selectedDate, dateRange: dateRange)
                }
                
            case .monthly:
                HStack {
                    Text(dateFormatter.string(from: selectedDate))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Button {
                        showMonthPicker = true
                    } label: {
                        Image(systemName: "calendar")
                            .foregroundStyle(.blue)
                    }
                    .sheet(isPresented: $showMonthPicker) {
                        MonthPickerView(
                            selection: $selectedDate,
                            dateRange: dateRange,
                            showPicker: $showMonthPicker
                        )
                    }
                }
                
            case .yearly:
                HStack {
                    Text(dateFormatter.string(from: selectedDate))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Button {
                        showYearPicker = true
                    } label: {
                        Image(systemName: "calendar")
                            .foregroundStyle(.blue)
                    }
                    .sheet(isPresented: $showYearPicker) {
                        YearPickerView(
                            selection: $selectedDate,
                            dateRange: dateRange,
                            showPicker: $showYearPicker
                        )
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Create Budget")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.blue, .blue.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            // Form Content
            VStack(spacing: 16) {
                TextField("Budget Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                HStack {
                    Text("Currency")
                    Spacer()
                    Picker("", selection: $selectedCurrency) {
                        ForEach(Currency.allCases) { currency in
                            Text("\(currency.symbol) \(currency.name)")
                                .tag(currency)
                        }
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Frequency")
                    Spacer()
                    Picker("", selection: $selectedFrequency) {
                        ForEach(BudgetFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue)
                                .tag(frequency)
                        }
                    }
                }
                .padding(.horizontal)
                .onChange(of: selectedFrequency) {
                    adjustDate()
                }
                
                HStack {
                    Spacer()
                    dateSelectionView
                }
                .padding(.horizontal)
                
                Button(action: createBudget) {
                    Text("Create")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(name.isEmpty ? .gray : .blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .disabled(name.isEmpty)
                .padding()
            }
            .padding(.top)
            .background(.white)
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert("Budget Created", isPresented: $showingSuccessAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("\(name) budget has been created")
        }
    }
    
    private func createBudget() {
        let budget = Budget(
            name: name,
            currency: selectedCurrency,
            frequency: selectedFrequency,
            date: selectedDate
        )
        
        withAnimation {
            budgetStore.addBudget(budget)
            showingSuccessAlert = true
        }
    }
}

// Date Extensions
extension Date {
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    func startOfYear() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        return calendar.date(from: components) ?? self
    }
    
    func nextWeekend() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        components.weekday = 1 // Sunday
        return calendar.date(from: components) ?? self
    }
}

// Custom Month Picker View
struct MonthPickerView: View {
    @Binding var selection: Date
    let dateRange: ClosedRange<Date>
    @Binding var showPicker: Bool
    
    private var months: [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        
        guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: dateRange.lowerBound)),
              let endDate = calendar.date(from: calendar.dateComponents([.year, .month], from: dateRange.upperBound)) else {
            return []
        }
        
        var currentDate = startDate
        while currentDate <= endDate {
            dates.append(currentDate)
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) {
                currentDate = nextMonth
            } else {
                break
            }
        }
        
        return dates
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List(months, id: \.self) { date in
                Button {
                    selection = date
                    showPicker = false
                } label: {
                    Text(dateFormatter.string(from: date))
                        .foregroundStyle(Calendar.current.isDate(date, equalTo: selection, toGranularity: .month) ? .blue : .primary)
                }
            }
            .navigationTitle("Select Month")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showPicker = false
                    }
                }
            }
        }
    }
}

// Custom Year Picker View
struct YearPickerView: View {
    @Binding var selection: Date
    let dateRange: ClosedRange<Date>
    @Binding var showPicker: Bool
    
    private var years: [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        
        guard let startDate = calendar.date(from: calendar.dateComponents([.year], from: dateRange.lowerBound)),
              let endDate = calendar.date(from: calendar.dateComponents([.year], from: dateRange.upperBound)) else {
            return []
        }
        
        var currentDate = startDate
        while currentDate <= endDate {
            dates.append(currentDate)
            if let nextYear = calendar.date(byAdding: .year, value: 1, to: currentDate) {
                currentDate = nextYear
            } else {
                break
            }
        }
        
        return dates
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List(years, id: \.self) { date in
                Button {
                    selection = date
                    showPicker = false
                } label: {
                    Text(dateFormatter.string(from: date))
                        .foregroundStyle(Calendar.current.isDate(date, equalTo: selection, toGranularity: .year) ? .blue : .primary)
                }
            }
            .navigationTitle("Select Year")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showPicker = false
                    }
                }
            }
        }
    }
}

// Custom Weekly Date Picker
struct WeeklyDatePicker: View {
    @Binding var selection: Date
    let dateRange: ClosedRange<Date>
    
    var body: some View {
        DatePicker(
            "",
            selection: $selection,
            in: dateRange,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .onChange(of: selection) {
            adjustToSunday()
        }
        .environment(\.calendar, Calendar.current)
        .tint(.blue)
        .transformEffect(.identity)
        .overlay {
            GeometryReader { geometry in
                let daysInWeek = 7
                let dayWidth = geometry.size.width / CGFloat(daysInWeek)
                
                // Dim all columns except the last one (Sunday)
                ForEach(0..<6) { index in  // 0 to 5 (Monday to Saturday)
                    Color.white
                        .opacity(0.6)
                        .frame(width: dayWidth)
                        .offset(x: dayWidth * CGFloat(index))
                }
            }
        }
    }
    
    private func adjustToSunday() {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: selection)
        if weekday != 1 { // 1 is Sunday
            if let nextSunday = calendar.nextDate(
                after: selection,
                matching: DateComponents(weekday: 1),
                matchingPolicy: .nextTime
            ) {
                selection = nextSunday
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateBudgetView(budgetStore: BudgetStore())
    }
} 