import Foundation

// MARK: - Color + SwiftUI Extensions
// Available on all Apple platforms (iOS 13+, macOS 10.15+, tvOS 13+, watchOS 6+)

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {
    /// Convert Color to SwiftUI Color
    public var swiftUIColor: SwiftUI.Color {
        return SwiftUI.Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
    
    /// Create Color from SwiftUI Color
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func fromSwiftUIColor(_ color: SwiftUI.Color) -> Color {
        #if canImport(UIKit)
        return fromUIColor(UIColor(color))
        #elseif canImport(AppKit)
        return fromNSColor(NSColor(color))
        #else
        // Fallback - this won't work perfectly but provides some compatibility
        return Color(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        #endif
    }
}
#endif
