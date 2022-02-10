#if canImport(UserNotifications) && os(iOS)
import Foundation
import UserNotifications

public protocol NotificationDeeplink: Deeplink, AnyNotificationDeeplink {

    associatedtype NotificationUserInfo
    associatedtype NotificationContext

    static func notificationUserInfoOptions(
        context: NotificationContext
    ) -> NotificationDeeplinkUserInfoOptions

    static func notification(
        requestIdentifier: String,
        categoryIdentifier: String,
        actionIdentifier: String,
        userInfo: NotificationUserInfo,
        context: NotificationContext
    ) throws -> Self?

    static func notification(
        response: UNNotificationResponse,
        userInfo: NotificationUserInfo,
        context: NotificationContext
    ) throws -> Self?
}

// MARK: - Context resolving

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

    public static func notification(
        response: UNNotificationResponse,
        userInfo: NotificationUserInfo,
        context: NotificationContext
    ) throws -> Self? {
        let request = response.notification.request

        return try notification(
            requestIdentifier: request.identifier,
            categoryIdentifier: request.content.categoryIdentifier,
            actionIdentifier: response.actionIdentifier,
            userInfo: userInfo,
            context: context
        )
    }
}

extension NotificationDeeplink where NotificationUserInfo == Any {

    public static func notification(
        response: UNNotificationResponse,
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyNotificationDeeplink? {
        try notification(
            response: response,
            userInfo: response.notification.request.content.userInfo,
            context: resolveContext(context)
        )
    }
}

extension NotificationDeeplink where NotificationUserInfo == [String: Any] {

    public static func notification(
        response: UNNotificationResponse,
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyNotificationDeeplink? {
        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else {
            throw NotificationDeeplinkInvalidUserInfoError(response: response, for: self)
        }

        return try notification(
            response: response,
            userInfo: userInfo,
            context: resolveContext(context)
        )
    }
}

extension NotificationDeeplink where NotificationUserInfo: Decodable {

    public static func notification(
        response: UNNotificationResponse,
        userInfoDecoder: NotificationDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyNotificationDeeplink? {
        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else {
            throw NotificationDeeplinkInvalidUserInfoError(response: response, for: self)
        }

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
            response: response,
            userInfo: decodedUserInfo,
            context: resolveContext(context)
        )
    }
}
#endif
