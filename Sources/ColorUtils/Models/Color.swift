import Foundation

/// Pure Swift color data structure - works anywhere Swift runs
/// No platform dependencies, pure color mathematics
public struct Color {
    public let red: Double
    public let green: Double
    public let blue: Double
    public let alpha: Double
    
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = max(0, min(1, red))
        self.green = max(0, min(1, green))
        self.blue = max(0, min(1, blue))
        self.alpha = max(0, min(1, alpha))
    }
    
    public init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 255) {
        self.red = Double(r) / 255.0
        self.green = Double(g) / 255.0
        self.blue = Double(b) / 255.0
        self.alpha = Double(a) / 255.0
    }
    
    public init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        
        switch hex.count {
        case 3: // RGB (12-bit)
            self.init(
                red: Double((int >> 8) * 17) / 255.0,
                green: Double((int >> 4 & 0xF) * 17) / 255.0,
                blue: Double((int & 0xF) * 17) / 255.0,
                alpha: 1.0
            )
        case 6: // RGB (24-bit)
            self.init(
                red: Double(int >> 16) / 255.0,
                green: Double(int >> 8 & 0xFF) / 255.0,
                blue: Double(int & 0xFF) / 255.0,
                alpha: 1.0
            )
        case 8: // ARGB (32-bit)
            self.init(
                red: Double(int >> 16 & 0xFF) / 255.0,
                green: Double(int >> 8 & 0xFF) / 255.0,
                blue: Double(int & 0xFF) / 255.0,
                alpha: Double(int >> 24) / 255.0
            )
        default:
            return nil
        }
    }
    
    // MARK: - HSB Color Space Support
    public struct HSB {
        public let hue: Double        // 0-360
        public let saturation: Double // 0-1
        public let brightness: Double // 0-1
    }
    
    public var hsb: HSB {
        let r = red
        let g = green
        let b = blue
        
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)
        let delta = max - min
        
        let brightness = max
        let saturation = max == 0 ? 0 : delta / max
        
        var hue: Double = 0
        
        if delta != 0 {
            switch max {
            case r:
                hue = 60 * ((g - b) / delta)
            case g:
                hue = 60 * (2 + (b - r) / delta)
            case b:
                hue = 60 * (4 + (r - g) / delta)
            default:
                break
            }
        }
        
        if hue < 0 {
            hue += 360
        }
        
        return HSB(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    public init(hue: Double, saturation: Double, brightness: Double, alpha: Double = 1.0) {
        let h = hue / 60
        let c = brightness * saturation
        let x = c * (1 - abs(h.truncatingRemainder(dividingBy: 2) - 1))
        let m = brightness - c
        
        var rgb: (Double, Double, Double)
        
        switch Int(h) {
        case 0:
            rgb = (c, x, 0)
        case 1:
            rgb = (x, c, 0)
        case 2:
            rgb = (0, c, x)
        case 3:
            rgb = (0, x, c)
        case 4:
            rgb = (x, 0, c)
        case 5:
            rgb = (c, 0, x)
        default:
            rgb = (0, 0, 0)
        }
        
        self.init(
            red: rgb.0 + m,
            green: rgb.1 + m,
            blue: rgb.2 + m,
            alpha: alpha
        )
    }
}

// MARK: - Utilities
extension Color {
    /// Get hex string representation
    public var hexString: String {
        let r = UInt8(red * 255)
        let g = UInt8(green * 255)
        let b = UInt8(blue * 255)
        let a = UInt8(alpha * 255)
        
        if alpha < 1.0 {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
    
    /// Calculate luminance for accessibility
    public var luminance: Double {
        func sRGBToLinear(_ value: Double) -> Double {
            return value <= 0.03928 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
        }
        
        return 0.2126 * sRGBToLinear(red) + 0.7152 * sRGBToLinear(green) + 0.0722 * sRGBToLinear(blue)
    }
}

// MARK: - Equatable, Hashable
extension Color: Equatable, Hashable {
    public static func == (lhs: Color, rhs: Color) -> Bool {
        return abs(lhs.red - rhs.red) < 0.001 &&
               abs(lhs.green - rhs.green) < 0.001 &&
               abs(lhs.blue - rhs.blue) < 0.001 &&
               abs(lhs.alpha - rhs.alpha) < 0.001
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(red)
        hasher.combine(green)
        hasher.combine(blue)
        hasher.combine(alpha)
    }
}
