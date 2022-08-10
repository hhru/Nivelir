#if canImport(UserNotifications) && os(iOS)
import Foundation
import UserNotifications

/// Erased type of ``NotificationDeeplink`` protocol.
///
/// - SeeAlso: ``NotificationDeeplink``
/// - SeeAlso: ``DeeplinkManager``
public protocol AnyNotificationDeeplink: AnyDeeplink {

    /// Options for decoding `userInfo` from notification.
    ///
    /// Implement this method if you want to change the data decoding strategies from `userInfo` notification.
    /// To review the default options, see ``NotificationDeeplinkUserInfoOptions``.
    ///
    /// - Parameter context: Additional context for creating ``NotificationDeeplinkUserInfoOptions``.
    /// Must match the context type of ``NotificationDeeplink/NotificationContext``.
    ///
    /// - Returns: Returns new options for decoding `userInfo` from notification.
    static func notificationUserInfoOptions(
        context: Any?
    ) throws -> NotificationDeeplinkUserInfoOptions

    /// Creating a deep link from a notification.
    ///
    /// - Parameters:
    ///   - response: The user’s response to an actionable notification.
    ///   - userInfoDecoder: Decoder for decoding dictionary from `userInfo`.
    ///   - context: Additional context for checking and creating ``NotificationDeeplink``.
    ///   Must match the context type of ``NotificationDeeplink/NotificationContext``.
    /// - Returns: Returns a new instance of ``NotificationDeeplink`` that performs navigation from `response` data.
    /// Otherwise `nil` if the deep link from `response` cannot be handled.
    static func notification(
        response: UNNotificationResponse,
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyNotificationDeeplink?
}
#endif
