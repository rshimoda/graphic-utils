import Foundation

public enum ColorUtils {
    static let processors: [ColorProcessor.Type] = [
        CPUColorProcessor.self
    ]
}

extension ColorUtils: PlatformAvailability {
    static var isAvailable: Bool {
        true
    }
}

extension ColorUtils: ColorProcessor {
    public static func process(_ color: Color, operation: ColorOperation) -> Color {
        guard let firstAvailableProcessor = processors.first(where: { $0.isAvailable }) else {
            return color
        }
        return firstAvailableProcessor.process(color, operation: operation)
    }
}
