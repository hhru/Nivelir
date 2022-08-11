import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(UserNotifications)
import UserNotifications
#endif

/// Deep link handling from an external source.
///
/// The handler converts the external source (URL, Push-Notification, Shortcut)
/// into a suitable ``Deeplink`` to make the navigation.
/// If no suitable ``Deeplink`` was found, the handler methods will return `false`.
public protocol DeeplinkHandler {

    /// Returns a Boolean value that indicates whether ``URLDeeplink`` exists to handle the URL.
    ///
    /// - Parameters:
    ///   - url: A URL Scheme or Universal Link from `UIApplicationDelegate` or `UIWindowSceneDelegate`.
    ///
    ///   - context: Additional context for checking and creating ``URLDeeplink``.
    ///   Must match the context type of ``URLDeeplink/URLContext``.
    ///
    /// - Returns: `false` if there is no suitable ``URLDeeplink`` to handle the URL; otherwise `true`.
    func canHandleURL(
        _ url: URL,
        context: Any?
    ) -> Bool

    /// Handle the URL by a suitable ``URLDeeplink`` and perform navigation, if possible.
    ///
    /// - Parameters:
    ///   - url: A URL Scheme or Universal Link from `UIApplicationDelegate` or `UIWindowSceneDelegate`.
    ///
    ///   - context: Additional context for checking and creating ``URLDeeplink``.
    ///   Must match the context type of ``URLDeeplink/URLContext``.
    ///
    /// - Returns: `false` if there is no suitable ``URLDeeplink`` to handle the URL; otherwise `true`.
    @discardableResult
    func handleURL(_ url: URL, context: Any?) throws -> Bool

    #if canImport(UserNotifications) && os(iOS)
    /// Returns a Boolean value that indicates whether ``NotificationDeeplink`` exists to handle the Notification.
    ///
    /// - Parameters:
    ///   - response: The user’s response to an actionable notification.
    ///   - context: Additional context for checking and creating ``NotificationDeeplink``.
    ///   Must match the context type of ``NotificationDeeplink/NotificationContext``.
    ///
    /// - Returns: `false` if there is no suitable ``NotificationDeeplink`` to handle the Notification;
    /// otherwise `true`.
    func canHandleNotification(
        response: UNNotificationResponse,
        context: Any?
    ) -> Bool

    /// Handle the Notification by a suitable ``NotificationDeeplink`` and perform navigation, if possible.
    ///
    /// - Parameters:
    ///   - response: The user’s response to an actionable notification.
    ///   - context: Additional context for checking and creating ``NotificationDeeplink``.
    ///   Must match the context type of ``NotificationDeeplink/NotificationContext``.
    /// - Returns: `false` if there is no suitable ``NotificationDeeplink`` to handle the Notification;
    /// otherwise `true`.
    @discardableResult
    func handleNotification(
        response: UNNotificationResponse,
        context: Any?
    ) throws -> Bool
    #endif

    #if canImport(UIKit) && os(iOS)
    /// Returns a Boolean value that indicates whether ``ShortcutDeeplink`` exists to handle the Shortcut App.
    ///
    /// - Parameters:
    ///   - shortcut: An application shortcut item, also called a *Home screen dynamic quick action*,
    ///   that specifies a user-initiated action for your app.
    ///
    ///   - context: Additional context for checking and creating ``ShortcutDeeplink``.
    ///   Must match the context type of ``ShortcutDeeplink/ShortcutContext``.
    ///
    /// - Returns: `false` if there is no suitable ``ShortcutDeeplink`` to handle the Shortcut App;
    /// otherwise `true`.
    func canHandleShortcut(
        _ shortcut: UIApplicationShortcutItem,
        context: Any?
    ) -> Bool

    /// Handle the Notification by a suitable ``NotificationDeeplink`` and perform navigation, if possible.
    ///
    /// - Parameters:
    ///   - shortcut: An application shortcut item, also called a *Home screen dynamic quick action*,
    ///   that specifies a user-initiated action for your app.
    ///
    ///   - context: Additional context for checking and creating ``ShortcutDeeplink``.
    ///   Must match the context type of ``ShortcutDeeplink/ShortcutContext``.
    ///
    /// - Returns: `false` if there is no suitable ``ShortcutDeeplink`` to handle the Shortcut App;
    /// otherwise `true`.
    @discardableResult
    func handleShortcut(
        _ shortcut: UIApplicationShortcutItem,
        context: Any?
    ) throws -> Bool
    #endif
}
