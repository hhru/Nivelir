import Foundation

/// The `Screens` instance is not supported by the deeplink type.
public struct DeeplinkInvalidScreensError: DeeplinkError {

    public let description: String

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - screens: Screens instance.
    ///   - type: Expected screens type.
    ///   - trigger: The deeplink that caused the error.
    public init(
        screens: Any?,
        type: Any.Type,
        for trigger: Any
    ) {
        description = """
        The type of the screens \(screens ?? "nil") does not match the expected type \(type) for:
          \(trigger)
        """
    }
}
