import Foundation

public protocol NotificationDeeplink: Deeplink, AnyNotificationDeeplink {

    associatedtype NotificationUserInfo
    associatedtype Context

    static func notificationUserInfoOptions(
        context: Context?
    ) -> NotificationDeeplinkUserInfoOptions

    static func notification(
        userInfo: NotificationUserInfo,
        context: Context?
    ) throws -> Self?
}

extension NotificationDeeplink {

    public static func notificationUserInfoOptions(
        context: Context?
    ) -> NotificationDeeplinkUserInfoOptions {
        NotificationDeeplinkUserInfoOptions()
    }

    public static func notificationUserInfoOptions(
        context: Any?
    ) throws -> NotificationDeeplinkUserInfoOptions {
        notificationUserInfoOptions(context: try resolveContext(context))
    }
}

extension NotificationDeeplink where NotificationUserInfo == Void {

    public static func notification(
        userInfo: [String: Any],
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyNotificationDeeplink? {
        try notification(
            userInfo: Void(),
            context: resolveContext(context)
        )
    }
}

extension NotificationDeeplink where NotificationUserInfo == [String: Any] {

    public static func notification(
        userInfo: [String: Any],
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyNotificationDeeplink? {
        try notification(
            userInfo: userInfo,
            context: resolveContext(context)
        )
    }
}

extension NotificationDeeplink where NotificationUserInfo: Decodable {

    public static func notification(
        userInfo: [String: Any],
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyNotificationDeeplink? {
        let decodedUserInfo: NotificationUserInfo

        do {
            decodedUserInfo = try userInfoDecoder.decode(
                NotificationUserInfo.self,
                from: userInfo
            )
        } catch {
            throw DeeplinkDecodingError(
                underlyingError: error,
                trigger: self
            )
        }

        return try notification(
            userInfo: decodedUserInfo,
            context: resolveContext(context)
        )
    }
}
