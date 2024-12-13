enum Category: String, Codable, CaseIterable {
    case housing = "Housing"
    case transportation = "Transportation"
    case food = "Food"
    case utilities = "Utilities"
    case insurance = "Insurance"
    case healthcare = "Healthcare"
    case savings = "Savings"
    case personal = "Personal"
    case entertainment = "Entertainment"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .housing: return "house.fill"
        case .transportation: return "car.fill"
        case .food: return "fork.knife"
        case .utilities: return "bolt.fill"
        case .insurance: return "shield.fill"
        case .healthcare: return "cross.case.fill"
        case .savings: return "banknote"
        case .personal: return "person.fill"
        case .entertainment: return "tv.fill"
        case .other: return "circle.grid.2x2.fill"
        }
    }
} 