import Foundation

/// Failed to extract components from deeplink URL.
public struct URLDeeplinkInvalidComponentsError: DeeplinkError {

    public var description: String {
        """
        Failed to extract components from URL "\(url)" for:
          \(trigger)
        """
    }

    /// A URL that caused the error.
    public let url: URL

    /// The deeplink that caused the error.
    public let trigger: Any

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - url: A URL that caused the error.
    ///   - trigger: The deeplink that caused the error.
    public init(
        url: URL,
        for trigger: Any
    ) {
        self.url = url
        self.trigger = trigger
    }
}
