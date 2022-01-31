import Foundation

/// The `Routes` instance is not supported by the deeplink type.
public struct DeeplinkInvalidRoutesError: DeeplinkError {

    public var description: String {
        """
        The type of the routes \(routes) does not match the expected type \(type) for:
          \(trigger)
        """
    }

    /// Routes instance.
    public let routes: Any

    /// Expected routes type.
    public let type: Any.Type

    /// The deeplink that caused the error.
    public let trigger: Any

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - routes: Routes instance.
    ///   - type: Expected routes type.
    ///   - trigger: The deeplink that caused the error.
    public init(
        routes: Any,
        type: Any.Type,
        for trigger: Any
    ) {
        self.routes = routes
        self.type = type
        self.trigger = trigger
    }
}
