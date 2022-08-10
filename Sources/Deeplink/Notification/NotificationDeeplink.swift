#if canImport(UserNotifications) && os(iOS)
import Foundation
import UserNotifications

/// The type of ``Deeplink`` that is handled from the Notification.
///
/// This type allows you to handle the deep link from the notification data, which comes via function parameters.
///
/// Nivelir can decode `userInfo` depending on the type of ``NotificationUserInfo``.
/// For example, if ``NotificationUserInfo`` implements the `Decodable` protocol,
/// then there is no need to manually parse
/// the dictionary of `userInfo` – check for keys and cast them to the correct type.
/// Instead, the dictionary will be automatically decoded
/// into an instance of the ``NotificationUserInfo`` type (like with JSON).
/// The options for decoding are set via ``NotificationDeeplinkUserInfoOptions``.
///
/// You may need additional context to check and create an instance.
/// For example, it may be a service factory from which additional data can be obtained.
/// The associated type ``NotificationContext`` is used for this purpose.
public protocol NotificationDeeplink: Deeplink, AnyNotificationDeeplink {

    /// The type of user information associated with the notification.
    associatedtype NotificationUserInfo

    /// Type of context for checking and creating a deep link instance.
    associatedtype NotificationContext

    /// Options for decoding `userInfo` from notification.
    ///
    /// Implement this method if you want to change the data decoding strategies from `userInfo` notification.
    /// To review the default options, see ``NotificationDeeplinkUserInfoOptions``.
    ///
    /// - Parameter context: Additional context for creating ``NotificationDeeplinkUserInfoOptions``.
    /// - Returns: Returns new options for decoding `userInfo` from notification.
    static func notificationUserInfoOptions(
        context: NotificationContext
    ) -> NotificationDeeplinkUserInfoOptions

    /// Creating a deep link from data of `UNNotificationResponse`.
    ///
    /// - Parameters:
    ///   - requestIdentifier: [The unique identifier for this notification request.
    ///   [Details](https://developer.apple.com/documentation/usernotifications/unnotificationrequest/1649634-identifier).
    ///
    ///   - categoryIdentifier: The identifier of the app-defined category object.
    ///   [Details](https://developer.apple.com/documentation/usernotifications/unnotificationcontent/1649866-categoryidentifier).
    ///
    ///   - actionIdentifier: The identifier string of the action that the user selected.
    ///   [Details](https://developer.apple.com/documentation/usernotifications/unnotificationresponse/1649548-actionidentifier).
    ///
    ///   - userInfo: Custom information associated with the notification.
    ///   - context: Additional context for checking and creating instance.
    /// - Returns: Returns a new instance of ``NotificationDeeplink`` that performs navigation.
    /// Otherwise `nil` if the deep link cannot be handled.
    static func notification(
        requestIdentifier: String,
        categoryIdentifier: String,
        actionIdentifier: String,
        userInfo: NotificationUserInfo,
        context: NotificationContext
    ) throws -> Self?

    /// Creating a deep link from `UNNotificationResponse`.
    ///
    /// - Parameters:
    ///   - response: The user’s response to an actionable notification.
    ///   - userInfo: Custom information associated with the notification.
    ///   - context: Additional context for checking and creating instance.
    /// - Returns: Returns a new instance of ``NotificationDeeplink`` that performs navigation from `response` data.
    /// Otherwise `nil` if the deep link from `response` cannot be handled.
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

    /// Options for decoding `userInfo` from notification.
    ///
    /// Implement this method if you want to change the data decoding strategies from `userInfo` notification.
    /// To review the default options, see ``NotificationDeeplinkUserInfoOptions``.
    ///
    /// - Parameter context: Additional context for creating ``NotificationDeeplinkUserInfoOptions``.
    /// - Returns: Returns new options for decoding `userInfo` from notification.
    public static func notificationUserInfoOptions(
        context: NotificationContext
    ) -> NotificationDeeplinkUserInfoOptions {
        NotificationDeeplinkUserInfoOptions()
    }

    /// Options for decoding `userInfo` from notification.
    ///
    /// Implement this method if you want to change the data decoding strategies from `userInfo` notification.
    /// To review the default options, see ``NotificationDeeplinkUserInfoOptions``.
    ///
    /// - Parameter context: Additional context for creating ``NotificationDeeplinkUserInfoOptions``.
    /// Must match the context type of ``NotificationDeeplink/NotificationContext``.
    ///
    /// - Returns: Returns new options for decoding `userInfo` from notification.
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
