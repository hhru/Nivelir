import Foundation

/// The `Screens` instance is not supported by the deeplink type.
public struct DeeplinkInvalidScreensError: DeeplinkError {

    public var description: String {
        """
        The type of the screens \(screens ?? "nil") does not match the expected type \(type) for:
          \(trigger)
        """
    }

    /// Screens instance.
    public let screens: Any?

    /// Expected screens type.
    public let type: Any.Type

    /// The deeplink that caused the error.
    public let trigger: Any

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
        self.screens = screens
        self.type = type
        self.trigger = trigger
    }
}
