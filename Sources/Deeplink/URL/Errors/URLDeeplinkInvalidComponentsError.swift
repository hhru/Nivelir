import Foundation

/// Failed to extract components from deeplink URL.
public struct URLDeeplinkInvalidComponentsError: DeeplinkError {

    public let description: String

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - url: A URL that caused the error.
    ///   - trigger: The deeplink that caused the error.
    public init(
        url: URL,
        for trigger: Any
    ) {
        description = """
        Failed to extract components from URL "\(url)" for:
          \(trigger)
        """
    }
}
