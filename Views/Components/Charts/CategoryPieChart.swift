import SwiftUI
import Charts

struct CategoryPieChart: View {
    let categories: [Category]
    
    var body: some View {
        Chart {
            ForEach(categories) { category in
                SectorMark(
                    angle: .value("Spent", category.spent),
                    innerRadius: .ratio(0.618),
                    angularInset: 1
                )
                .foregroundStyle(category.color)
                .annotation(position: .overlay) {
                    Text(category.name)
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(height: 300)
        .padding()
        .cardStyle()
    }
} 