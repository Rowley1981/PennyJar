import Foundation

struct Currency: Identifiable, Codable, Hashable {
    let id: UUID
    let code: String
    let name: String
    let symbol: String
    
    init(id: UUID = UUID(), code: String, name: String, symbol: String) {
        self.id = id
        self.code = code
        self.name = name
        self.symbol = symbol
    }
}

extension Currency {
    static let usd = Currency(code: "USD", name: "US Dollar", symbol: "$")
    static let eur = Currency(code: "EUR", name: "Euro", symbol: "€")
    static let gbp = Currency(code: "GBP", name: "British Pound", symbol: "£")
    static let jpy = Currency(code: "JPY", name: "Japanese Yen", symbol: "¥")
    static let aud = Currency(code: "AUD", name: "Australian Dollar", symbol: "A$")
    static let cad = Currency(code: "CAD", name: "Canadian Dollar", symbol: "C$")
    
    static let allCases: [Currency] = [
        .usd, .eur, .gbp, .jpy, .aud, .cad
        // Add more currencies as needed
    ]
} 