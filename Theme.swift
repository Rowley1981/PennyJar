enum Theme {
    static let darkBlue = Color(hex: "03045E")
    static let mediumBlue = Color(hex: "0077B6") 
    static let lightBlue = Color(hex: "00B4D8")
    static let paleBlue = Color(hex: "90E0EF")
    static let skyBlue = Color(hex: "CAF0F8")
    
    // Extension to support hex colors
    private extension Color {
        init(hex: String) {
            let scanner = Scanner(string: hex)
            var rgbValue: UInt64 = 0
            scanner.scanHexInt64(&rgbValue)
            
            let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
            let g = Double((rgbValue & 0xff00) >> 8) / 255.0
            let b = Double(rgbValue & 0xff) / 255.0
            
            self.init(red: r, green: g, blue: b)
        }
    }
} 