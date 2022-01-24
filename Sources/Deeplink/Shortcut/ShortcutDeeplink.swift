#if canImport(UIKit) && os(iOS)
import UIKit

public protocol ShortcutDeeplink: Deeplink, AnyShortcutDeeplink {

    associatedtype ShortcutUserInfo

    static func shortcut(type: String, userInfo: ShortcutUserInfo?) -> Self?
}

extension ShortcutDeeplink where ShortcutUserInfo == Void {

    public static func shortcut(
        _ shortcut: UIApplicationShortcutItem,
        userInfoDecoder: ShortcutDeeplinkUserInfoDecoder
    ) -> AnyShortcutDeeplink? {
        Self.shortcut(
            type: shortcut.type,
            userInfo: Void()
        )
    }
}

extension ShortcutDeeplink where ShortcutUserInfo == [String: Any] {

    public static func shortcut(
        _ shortcut: UIApplicationShortcutItem,
        userInfoDecoder: ShortcutDeeplinkUserInfoDecoder
    ) -> AnyShortcutDeeplink? {
        Self.shortcut(
            type: shortcut.type,
            userInfo: shortcut.userInfo
        )
    }
}

extension ShortcutDeeplink where ShortcutUserInfo: Decodable {

    public static func shortcut(
        _ shortcut: UIApplicationShortcutItem,
        userInfoDecoder: ShortcutDeeplinkUserInfoDecoder
    ) -> AnyShortcutDeeplink? {
        do {
            let userInfo = try shortcut.userInfo.map { userInfo in
                try userInfoDecoder.decode(
                    ShortcutUserInfo.self,
                    from: userInfo
                )
            }

            return Self.shortcut(
                type: shortcut.type,
                userInfo: userInfo
            )
        } catch {
            return nil
        }
    }
}
#endif
