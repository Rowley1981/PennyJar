import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @State private var searchText = ""
    
    private let iconService = IconRecommendationService()
    private let columns = Array(repeating: GridItem(.flexible()), count: 6)
    
    var filteredIcons: [String] {
        if searchText.isEmpty {
            return iconService.allIcons
        }
        return iconService.recommendIcons(for: searchText)
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredIcons, id: \.self) { icon in
                        Image(systemName: icon)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                            .background(selectedIcon == icon ? Color.accentColor.opacity(0.2) : Color.clear)
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedIcon = icon
                            }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Choose Icon")
    }
} 