#if canImport(UIKit) && os(iOS)
import UIKit

public protocol AnyShortcutDeeplink: AnyDeeplink {

    static func shortcut(
        _ shortcut: UIApplicationShortcutItem,
        userInfoDecoder: ShortcutDeeplinkUserInfoDecoder
    ) -> AnyShortcutDeeplink?
}
#endif
