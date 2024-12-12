import SwiftUI

struct CurrencyPicker: View {
    @Binding var selection: Currency
    
    private let commonCurrencies: [Currency] = [
        .init(code: "USD", name: "US Dollar", symbol: "$"),
        .init(code: "EUR", name: "Euro", symbol: "€"),
        .init(code: "GBP", name: "British Pound", symbol: "£"),
        .init(code: "JPY", name: "Japanese Yen", symbol: "¥"),
        .init(code: "CAD", name: "Canadian Dollar", symbol: "$"),
        .init(code: "AUD", name: "Australian Dollar", symbol: "$"),
        .init(code: "CHF", name: "Swiss Franc", symbol: "Fr"),
        .init(code: "CNY", name: "Chinese Yuan", symbol: "¥")
    ]
    
    var body: some View {
        List {
            Section("Common Currencies") {
                ForEach(commonCurrencies) { currency in
                    Button {
                        selection = currency
                    } label: {
                        HStack {
                            Text(currency.code)
                                .foregroundStyle(Theme.textPrimary)
                            Spacer()
                            Text(currency.symbol)
                                .foregroundStyle(Theme.textSecondary)
                            if currency == selection {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Theme.mediumBlue)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Currency")
        .navigationBarTitleDisplayMode(.inline)
    }
} 