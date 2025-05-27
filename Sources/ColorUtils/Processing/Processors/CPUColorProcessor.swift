import Foundation

enum CPUColorProcessor {}

extension CPUColorProcessor: ColorProcessor {
    static func process(_ color: Color, operation: ColorOperation) -> Color {
    switch operation {
        case .brightness(let factor):
            return brightness(color, factor: factor)
            
        case .saturation(let factor):
            return saturation(color, factor: factor)
            
        case .contrast(let factor):
            return contrast(color, factor: factor)
            
        case .invert:
            return invert(color)
            
        case .grayscale:
            return grayscale(color)
            
        case .blend(let otherColor, let mode):
            // For now, only normal blend mode is implemented in ColorProcessing
            guard mode == .normal else { return color }
            return blend(color, with: otherColor)
            
        case .hueShift(let degrees):
            return hueShift(color, degrees: degrees)
        }
    }
}

extension CPUColorProcessor: PlatformAvailability {
    public static var isAvailable: Bool {
        // Always available - pure Swift implementation
        true
    }
}

private extension CPUColorProcessor {
        /// Adjust brightness of a color
    static func brightness(_ color: Color, factor: Double) -> Color {
        let clampedFactor = max(0, min(2, factor))
        return Color(
            red: min(1, color.red * clampedFactor),
            green: min(1, color.green * clampedFactor),
            blue: min(1, color.blue * clampedFactor),
            alpha: color.alpha
        )
    }
    
    /// Adjust saturation using HSB color space
    static func saturation(_ color: Color, factor: Double) -> Color {
        let hsb = color.hsb
        let newSaturation = max(0, min(1, hsb.saturation * factor))
        return Color(
            hue: hsb.hue,
            saturation: newSaturation,
            brightness: hsb.brightness,
            alpha: color.alpha
        )
    }
    
    /// Adjust contrast of a color
    static func contrast(_ color: Color, factor: Double) -> Color {
        let clampedFactor = max(0, min(3, factor))
        
        let r = min(1, max(0, (color.red - 0.5) * clampedFactor + 0.5))
        let g = min(1, max(0, (color.green - 0.5) * clampedFactor + 0.5))
        let b = min(1, max(0, (color.blue - 0.5) * clampedFactor + 0.5))
        
        return Color(red: r, green: g, blue: b, alpha: color.alpha)
    }
    
    /// Invert color (negative)
    static func invert(_ color: Color) -> Color {
        return Color(
            red: 1.0 - color.red,
            green: 1.0 - color.green,
            blue: 1.0 - color.blue,
            alpha: color.alpha
        )
    }
    
    /// Convert to grayscale using luminance
    static func grayscale(_ color: Color) -> Color {
        let gray = 0.299 * color.red + 0.587 * color.green + 0.114 * color.blue
        return Color(red: gray, green: gray, blue: gray, alpha: color.alpha)
    }
    
    /// Blend two colors using alpha blending
    static func blend(_ color1: Color, with color2: Color) -> Color {
        let alpha1 = color1.alpha
        let alpha2 = color2.alpha
        let alphaOut = alpha1 + alpha2 * (1 - alpha1)
        
        guard alphaOut > 0 else {
            return Color(red: 0, green: 0, blue: 0, alpha: 0)
        }
        
        let red = (color1.red * alpha1 + color2.red * alpha2 * (1 - alpha1)) / alphaOut
        let green = (color1.green * alpha1 + color2.green * alpha2 * (1 - alpha1)) / alphaOut
        let blue = (color1.blue * alpha1 + color2.blue * alpha2 * (1 - alpha1)) / alphaOut
        
        return Color(red: red, green: green, blue: blue, alpha: alphaOut)
    }
    
    /// Adjust hue by shifting in HSB space
    static func hueShift(_ color: Color, degrees: Double) -> Color {
        let hsb = color.hsb
        var newHue = hsb.hue + degrees
        
        // Wrap around 0-360
        while newHue < 0 { newHue += 360 }
        while newHue >= 360 { newHue -= 360 }
        
        return Color(
            hue: newHue,
            saturation: hsb.saturation,
            brightness: hsb.brightness,
            alpha: color.alpha
        )
    }
}
