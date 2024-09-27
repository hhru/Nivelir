#if canImport(UserNotifications) && os(iOS)
import Foundation
import UserNotifications

/// Failed to extract userInfo from response to the notification.
public struct NotificationDeeplinkInvalidUserInfoError: DeeplinkError {

    public let description: String

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - response: Response to the notification that caused the error.
    ///   - trigger: The deeplink that caused the error.
    public init(
        response: UNNotificationResponse,
        for trigger: Any
    ) {
        description = """
        Failed to extract userInfo from response to the notification for:
          \(trigger)
        """
    }
}
#endif
