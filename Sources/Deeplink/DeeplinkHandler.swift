import Foundation

#if canImport(UIKit)
import UIKit
#endif

public protocol DeeplinkHandler {

    var navigator: ScreenNavigator { get }

    @discardableResult
    func handleURL(_ url: URL, context: Any?) throws -> Bool

    @discardableResult
    func handleNotification(userInfo: [String: Any], context: Any?) throws -> Bool

    #if os(iOS)
    @discardableResult
    func handleShortcut(_ shortcut: UIApplicationShortcutItem, context: Any?) throws -> Bool
    #endif
}
