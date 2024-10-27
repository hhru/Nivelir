import Foundation

/// Action canceled.
///
/// This error occurs whenever an action is canceled.
public struct ScreenCanceledError: ScreenError {

    public let description: String

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - trigger: The action that caused the error.
    public init(for trigger: Any) {
        description = """
        Action canceled:
          \(trigger)
        """
    }
}
