import Foundation

internal struct DeeplinkWarningsError: DeeplinkError {

    internal var description: String {
        let warnings = warnings
            .map { "\($0)" }
            .joined(separator: .newLine)
            .indented(spaces: 2)

        return """
        Failed to handle deeplink of \(deeplinkType) type with warnings:
        \(warnings)
        """
    }

    internal let deeplinkType: Any.Type
    internal let warnings: [Error]

    internal init(
        deeplinkType: Any.Type,
        warnings: [Error]
    ) {
        self.deeplinkType = deeplinkType
        self.warnings = warnings
    }
}
