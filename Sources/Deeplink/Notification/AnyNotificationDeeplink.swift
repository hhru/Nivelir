import Foundation

public protocol AnyNotificationDeeplink: AnyDeeplink {

    static func notification(
        userInfo: [String: Any],
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder
    ) -> AnyNotificationDeeplink?
}
