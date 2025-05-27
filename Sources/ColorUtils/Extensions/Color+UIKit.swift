import Foundation

// MARK: - Color + UIKit Extensions
// Available on iOS, tvOS, and macCatalyst

#if canImport(UIKit)
import UIKit

extension Color {
    /// Convert Color to UIColor
    public var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Create Color from UIColor
    public static func fromUIColor(_ color: UIColor) -> Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return Color(
            red: Double(red),
            green: Double(green),
            blue: Double(blue),
            alpha: Double(alpha)
        )
    }
}
#endif
