import Foundation

internal struct DeeplinkDecodingError: DeeplinkError {

    internal var description: String {
        """
        Failed to decode data for \(trigger) with error:
          \(underlyingError)
        """
    }

    internal let underlyingError: Any

    internal let trigger: Any

    internal init(
        underlyingError: Error,
        trigger: Any
    ) {
        self.underlyingError = underlyingError
        self.trigger = trigger
    }
}
