import SwiftUI

struct ProgressBar: View {
    let value: Double
    var color: Color = .blue
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundStyle(Color(.systemGray5))
                
                Rectangle()
                    .frame(width: geometry.size.width * value)
                    .foregroundStyle(color)
            }
        }
        .clipShape(Capsule())
    }
} 