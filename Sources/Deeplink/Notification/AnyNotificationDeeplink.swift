import Foundation

public protocol AnyNotificationDeeplink: AnyDeeplink {

    static func notificationUserInfoOptions(
        context: Any?
    ) throws -> NotificationDeeplinkUserInfoOptions

    static func notification(
        userInfo: [String: Any],
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyNotificationDeeplink?
}
