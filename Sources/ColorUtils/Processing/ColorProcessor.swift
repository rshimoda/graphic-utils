import Foundation

protocol ColorProcessor: PlatformAvailability {
    static func process(_ color: Color, operation: ColorOperation) -> Color
}
