import Foundation

/// Enumeration of all available color processing operations
/// Each case represents a specific color transformation with associated parameters
public enum ColorOperation: Equatable {
    case brightness(factor: Double)
    case saturation(factor: Double)
    case contrast(factor: Double)
    case invert
    case grayscale
    case blend(with: Color, mode: BlendMode)
    case hueShift(degrees: Double)
}
    
extension ColorOperation {
    /// Blend modes for color blending operations
    public enum BlendMode: String, CaseIterable {
        case normal
        case multiply
        case screen
        case overlay
        case softLight
        case hardLight
    }
}
    
extension ColorOperation {
    /// Validate operation parameters
    public var isValid: Bool {
        switch self {
        case .brightness(let factor):
            return factor >= 0 && factor <= 2
        case .saturation(let factor):
            return factor >= 0 && factor <= 2
        case .contrast(let factor):
            return factor >= 0 && factor <= 2
        case .hueShift(let degrees):
            return degrees >= -360 && degrees <= 360
        case .invert, .grayscale:
            return true
        case .blend(_, _):
            return true
        }
    }
}
 
extension ColorOperation {
    /// Human-readable description of the operation
    public var description: String {
        switch self {
        case .brightness(let factor):
            return "Brightness adjustment (factor: \(factor))"
        case .saturation(let factor):
            return "Saturation adjustment (factor: \(factor))"
        case .contrast(let factor):
            return "Contrast adjustment (factor: \(factor))"
        case .invert:
            return "Color inversion"
        case .grayscale:
            return "Grayscale conversion"
        case .blend(_, let mode):
            return "Color blending (\(mode.rawValue) mode)"
        case .hueShift(let degrees):
            return "Hue shift (\(degrees)°)"
        }
    }
}
