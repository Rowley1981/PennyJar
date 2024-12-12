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

#Preview {
    VStack {
        ProgressBar(value: 0.3)
            .frame(height: 8)
        ProgressBar(value: 0.7)
            .frame(height: 8)
        ProgressBar(value: 1.0)
            .frame(height: 8)
    }
    .padding()
} 