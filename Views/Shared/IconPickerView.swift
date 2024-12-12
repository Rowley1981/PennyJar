import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    // Top 250 SF Symbols (you'll need to populate this)
    let symbols = [
        "dollarsign.circle", "cart.fill", "house.fill", "car.fill", "tram.fill",
        "airplane", "bus", "ferry.fill", "bicycle", "figure.walk",
        "fork.knife", "cup.and.saucer.fill", "takeoutbag.and.cup.and.straw.fill",
        "house.fill", "building.columns.fill", "creditcard.fill", "banknote.fill",
        "gift.fill", "bag.fill", "cart.fill", "basket.fill",
        "cross.case.fill", "pills.fill", "heart.fill", "brain.head.profile",
        "dumbbell.fill", "sportscourt.fill", "figure.run", "figure.hiking",
        "gamecontroller.fill", "tv.fill", "movie.fill", "theatermasks.fill",
        "book.fill", "graduationcap.fill", "pencil.and.ruler.fill",
        "phone.fill", "wifi", "network", "bolt.fill", "drop.fill",
        "leaf.fill", "pawprint.fill", "scissors", "hammer.fill",
        "wrench.and.screwdriver.fill", "briefcase.fill"
    ]
    
    var filteredSymbols: [String] {
        if searchText.isEmpty {
            return symbols
        }
        let recommended = symbols.filter { $0.localizedCaseInsensitiveContains(searchText) }
        return recommended + symbols.filter { symbol in
            !recommended.contains(symbol) && 
            symbol.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 60))
                ], spacing: 20) {
                    ForEach(filteredSymbols, id: \.self) { symbol in
                        Button {
                            selectedIcon = symbol
                            dismiss()
                        } label: {
                            Image(systemName: symbol)
                                .font(.title)
                                .frame(width: 60, height: 60)
                                .background(selectedIcon == symbol ? Color.blue.opacity(0.2) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .padding()
            }
            .searchable(text: $searchText, prompt: "Search icons")
            .navigationTitle("Choose Icon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
} 