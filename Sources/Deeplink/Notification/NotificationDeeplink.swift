import Foundation

public protocol NotificationDeeplink: Deeplink, AnyNotificationDeeplink {

    associatedtype NotificationUserInfo
    associatedtype NotificationContext

    static func notificationUserInfoOptions(
        context: NotificationContext
    ) -> NotificationDeeplinkUserInfoOptions

    static func notification(
        userInfo: NotificationUserInfo,
        context: NotificationContext
    ) throws -> Self?
}

// MARK: - Helpers

extension NotificationDeeplink where NotificationContext: Nullable {

    private static func resolveContext(_ context: Any?) throws -> NotificationContext {
        guard let context = context else {
            return .none
        }

        guard let notificationContext = context as? NotificationContext else {
            throw DeeplinkInvalidContextError(
                context: context,
                type: NotificationContext.self,
                for: self
            )
        }

        return notificationContext
    }
}

extension NotificationDeeplink {

    private static func resolveContext(_ context: Any?) throws -> NotificationContext {
        guard let notificationContext = context as? NotificationContext else {
            throw DeeplinkInvalidContextError(
                context: context,
                type: NotificationContext.self,
                for: self
            )
        }

        return notificationContext
    }
}

// MARK: - Default implementation

extension NotificationDeeplink {

    public static func notificationUserInfoOptions(
        context: NotificationContext
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
