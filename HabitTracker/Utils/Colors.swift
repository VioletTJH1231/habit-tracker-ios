import SwiftUI

/// Extension to convert hex colors to SwiftUI Color
extension Color {
    /// Initialize Color from hex string
    /// - Parameter hex: Hex color string (e.g., "#FF6B6B" or "FF6B6B")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
    
    /// Convert Color to hex string
    /// - Returns: Hex string representation of the color (e.g., "#FF6B6B")
    func toHex() -> String {
        let components = self.cgColor?.components ?? [0, 0, 0, 1]
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02lX%02lX%02lX", r, g, b)
    }
}

/// Predefined app color palette
struct AppColors {
    static let primary = Color(hex: "#FF6B6B")
    static let secondary = Color(hex: "#4D96FF")
    static let accent = Color(hex: "#6BCB77")
    
    static let background = Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: "#1A1A1A") : UIColor(hex: "#F5F5F5") })
    static let surface = Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: "#2A2A2A") : UIColor.white })
    static let surfaceSecondary = Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: "#3A3A3A") : UIColor(hex: "#F0F0F0") })
    
    static let text = Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor.white : UIColor.black })
    static let textSecondary = Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: "#A0A0A0") : UIColor(hex: "#666666") })
    
    static let divider = Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(hex: "#444444") : UIColor(hex: "#EEEEEE") })
    static let success = Color(hex: "#6BCB77")
    static let warning = Color(hex: "#FFD93D")
    static let error = Color(hex: "#FF6B6B")
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = CGFloat((rgb >> 16) & 0xFF) / 255
        let g = CGFloat((rgb >> 8) & 0xFF) / 255
        let b = CGFloat(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
