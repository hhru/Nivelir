#if canImport(UIKit) && os(iOS)
import UIKit

public protocol AnyShortcutDeeplink: AnyDeeplink {

    static func shortcut(
        _ shortcut: UIApplicationShortcutItem,
        userInfoDecoder: ShortcutDeeplinkUserInfoDecoder
    ) -> AnyShortcutDeeplink?
}

internal struct Routes { }

internal struct SomeDeeplink: ShortcutDeeplink, NotificationDeeplink {

    static func notification(userInfo: Void) -> SomeDeeplink? {
        nil
    }

    internal static func shortcut(type: String, userInfo: Void?) -> Self? {
        nil
    }

    internal func navigate(using routes: Routes) {

    }
}
#endif
