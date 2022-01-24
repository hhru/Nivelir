import Foundation

public protocol NotificationDeeplink: Deeplink, AnyNotificationDeeplink {

    associatedtype NotificationUserInfo

    static func notification(userInfo: NotificationUserInfo) -> Self?
}

extension NotificationDeeplink where NotificationUserInfo == Void {

    public static func notification(
        userInfo: [String: Any],
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder
    ) -> AnyNotificationDeeplink? {
        Self.notification(userInfo: Void())
    }
}

extension NotificationDeeplink where NotificationUserInfo == [String: Any] {

    public static func notification(
        userInfo: [String: Any],
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder
    ) -> AnyNotificationDeeplink? {
        Self.notification(userInfo: userInfo)
    }
}

extension NotificationDeeplink where NotificationUserInfo: Decodable {

    public static func notification(
        userInfo: [String: Any],
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder
    ) -> AnyNotificationDeeplink? {
        do {
            let userInfo = try userInfoDecoder.decode(
                NotificationUserInfo.self,
                from: userInfo
            )

            return Self.notification(userInfo: userInfo)
        } catch {
            return nil
        }
    }
}
