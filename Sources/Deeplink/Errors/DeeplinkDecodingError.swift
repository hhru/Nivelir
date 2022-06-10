import Foundation

internal struct DeeplinkDecodingError: DeeplinkError {

    internal var description: String {
        """
        Failed to decode data for \(trigger) with error:
          \(underlyingError)
        """
    }

    internal let underlyingError: Error

    internal let trigger: Any

    internal var isWarning: Bool {
        true
    }

    internal init(
        underlyingError: Error,
        trigger: Any
    ) {
        self.underlyingError = underlyingError
        self.trigger = trigger
    }
}
