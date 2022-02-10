import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(UserNotifications)
import UserNotifications
#endif

public protocol DeeplinkHandler {

    @discardableResult
    func handleURL(_ url: URL, context: Any?) throws -> Bool

    #if canImport(UserNotifications) && os(iOS)
    @discardableResult
    func handleNotification(response: UNNotificationResponse, context: Any?) throws -> Bool
    #endif

    #if canImport(UIKit) && os(iOS)
    @discardableResult
    func handleShortcut(_ shortcut: UIApplicationShortcutItem, context: Any?) throws -> Bool
    #endif
}
