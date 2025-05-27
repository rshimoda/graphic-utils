import Foundation

// MARK: - Color + AppKit Extensions
// Available on macOS (excluding macCatalyst)

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension Color {
    /// Convert Color to NSColor
    public var nsColor: NSColor {
        return NSColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Create Color from NSColor
    public static func fromNSColor(_ color: NSColor) -> Color {
        let rgbColor = color.usingColorSpace(.deviceRGB) ?? color
        return Color(
            red: Double(rgbColor.redComponent),
            green: Double(rgbColor.greenComponent),
            blue: Double(rgbColor.blueComponent),
            alpha: Double(rgbColor.alphaComponent)
        )
    }
}
#endif
