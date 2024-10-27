import Foundation

/// The `Context` instance is not supported by the deeplink type.
public struct DeeplinkInvalidContextError: DeeplinkError {

    public let description: String

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - context: Context instance.
    ///   - type: Expected context type.
    ///   - trigger: The deeplink that caused the error.
    public init(
        context: Any?,
        type: Any.Type,
        for trigger: Any
    ) {
        description = """
        The type of the context \(context ?? "nil") does not match the expected type \(type) for:
          \(trigger)
        """
    }
}
