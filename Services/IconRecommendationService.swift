import Foundation

final class IconRecommendationService {
    static let shared = IconRecommendationService()
    
    private let allIcons = [
        "cart.fill", "house.fill", "car.fill", "airplane", "heart.fill",
        "creditcard.fill", "gift.fill", "bag.fill", "tram.fill", "medical.fill"
    ]
    
    private init() {}
    
    func recommendIcons(for searchText: String, limit: Int) -> [String] {
        if searchText.isEmpty {
            return Array(allIcons.prefix(limit))
        }
        return allIcons
            .filter { $0.localizedCaseInsensitiveContains(searchText) }
            .prefix(limit)
            .map { $0 }
    }
} 