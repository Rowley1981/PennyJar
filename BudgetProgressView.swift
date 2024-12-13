struct BudgetProgressView: View {
    let spent: Double
    let total: Double
    
    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(spent / total, 1.0)
    }
    
    private var progressColor: Color {
        switch progress {
        case 0..<0.7: return .green
        case 0.7..<0.9: return .yellow
        default: return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ProgressView(value: progress)
                .tint(progressColor)
            
            HStack {
                Text("Spent: \(spent, format: .currency(code: "USD"))")
                Spacer()
                Text("Remaining: \((total - spent), format: .currency(code: "USD"))")
            }
            .font(.caption)
        }
    }
} 