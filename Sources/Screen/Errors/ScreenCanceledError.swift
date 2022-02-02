import Foundation

/// Action canceled.
///
/// This error occurs whenever an action is canceled.
public struct ScreenCanceledError: ScreenError {

    public var description: String {
        """
        Action canceled:
          \(trigger)
        """
    }

    /// The action that caused the error.
    public let trigger: Any

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - trigger: The action that caused the error.
    public init(for trigger: Any) {
        self.trigger = trigger
    }
}
