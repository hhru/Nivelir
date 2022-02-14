import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(UserNotifications)
import UserNotifications
#endif

public protocol DeeplinkHandler {

    func canHandleURL(
        _ url: URL,
        context: Any?
    ) -> Bool

    @discardableResult
    func handleURL(_ url: URL, context: Any?) throws -> Bool

    #if canImport(UserNotifications) && os(iOS)
    func canHandleNotification(
        response: UNNotificationResponse,
        context: Any?
    ) -> Bool

    @discardableResult
    func handleNotification(
        response: UNNotificationResponse,
        context: Any?
    ) throws -> Bool
    #endif

    #if canImport(UIKit) && os(iOS)
    func canHandleShortcut(
        _ shortcut: UIApplicationShortcutItem,
        context: Any?
    ) -> Bool

    @discardableResult
    func handleShortcut(
        _ shortcut: UIApplicationShortcutItem,
        context: Any?
    ) throws -> Bool
    #endif
}
