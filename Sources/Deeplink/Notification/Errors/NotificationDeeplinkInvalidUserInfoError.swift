#if canImport(UserNotifications) && os(iOS)
import Foundation
import UserNotifications

/// Failed to extract userInfo from response to the notification.
public struct NotificationDeeplinkInvalidUserInfoError: DeeplinkError {

    public var description: String {
        """
        Failed to extract userInfo from response to the notification for:
          \(trigger)
        """
    }

    /// Response to the notification that caused the error.
    public let response: UNNotificationResponse

    /// The deeplink that caused the error.
    public let trigger: Any

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - response: Response to the notification that caused the error.
    ///   - trigger: The deeplink that caused the error.
    public init(
        response: UNNotificationResponse,
        for trigger: Any
    ) {
        self.response = response
        self.trigger = trigger
    }
}
#endif
