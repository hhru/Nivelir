import Foundation

internal struct DeeplinkDecodingError: DeeplinkError {

    internal let description: String

    internal var isWarning: Bool {
        true
    }

    internal init(
        underlyingError: Error,
        trigger: Any
    ) {
        description = """
        Failed to decode data for \(trigger) with error:
          \(underlyingError)
        """
    }
}
