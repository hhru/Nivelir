#if canImport(UserNotifications) && os(iOS)
import Foundation
import UserNotifications

public protocol AnyNotificationDeeplink: AnyDeeplink {

    static func notificationUserInfoOptions(
        context: Any?
    ) throws -> NotificationDeeplinkUserInfoOptions

    static func notification(
        response: UNNotificationResponse,
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyNotificationDeeplink?
}
#endif
