import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    let icons = [
        "cart.fill",
        "house.fill",
        "car.fill",
        "tram.fill",
        "airplane",
        "bus.fill",
        "fork.knife",
        "cup.and.saucer.fill",
        "gift.fill",
        "creditcard.fill",
        "medical.thermometer.fill",
        "cross.case.fill",
        "dumbbell.fill",
        "gamecontroller.fill",
        "theatermasks.fill",
        "ticket.fill",
        "book.fill",
        "graduationcap.fill",
        "briefcase.fill",
        "case.fill",
        // Add more icons as needed
    ]
    
    var filteredIcons: [String] {
        if searchText.isEmpty {
            return icons
        }
        return icons.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        List {
            ForEach(filteredIcons, id: \.self) { icon in
                Button {
                    selectedIcon = icon
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: icon)
                            .font(.title2)
                            .frame(width: 30)
                        Text(icon)
                            .foregroundStyle(Theme.textPrimary)
                        Spacer()
                        if icon == selectedIcon {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Theme.mediumBlue)
                        }
                    }
                }
            }
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