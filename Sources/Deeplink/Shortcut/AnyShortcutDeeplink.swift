#if canImport(UIKit) && os(iOS)
import UIKit

public protocol AnyShortcutDeeplink: AnyDeeplink {

    static func shortcutUserInfoOptions(
        context: Any?
    ) throws -> ShortcutDeeplinkUserInfoOptions

    static func shortcut(
        _ shortcut: UIApplicationShortcutItem,
        userInfoDecoder: ShortcutDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyShortcutDeeplink?
}
#endif
