#if canImport(UIKit) && os(iOS)
import UIKit

public protocol ShortcutDeeplink: Deeplink, AnyShortcutDeeplink {

    associatedtype ShortcutUserInfo
    associatedtype Context

    static func shortcutUserInfoOptions(
        context: Context?
    ) -> ShortcutDeeplinkUserInfoOptions

    static func shortcut(
        type: String,
        userInfo: ShortcutUserInfo?,
        context: Context?
    ) throws -> Self?
}

extension ShortcutDeeplink {

    public static func shortcutUserInfoOptions(
        context: Context?
    ) -> ShortcutDeeplinkUserInfoOptions {
        ShortcutDeeplinkUserInfoOptions()
    }

    public static func shortcutUserInfoOptions(
        context: Any?
    ) throws -> ShortcutDeeplinkUserInfoOptions {
        shortcutUserInfoOptions(context: try resolveContext(context))
    }
}

extension ShortcutDeeplink where ShortcutUserInfo == Void {

    public static func shortcut(
        _ shortcut: UIApplicationShortcutItem,
        userInfoDecoder: ShortcutDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyShortcutDeeplink? {
        try Self.shortcut(
            type: shortcut.type,
            userInfo: Void(),
            context: resolveContext(context)
        )
    }
}

extension ShortcutDeeplink where ShortcutUserInfo == [String: Any] {

    public static func shortcut(
        _ shortcut: UIApplicationShortcutItem,
        userInfoDecoder: ShortcutDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyShortcutDeeplink? {
        try Self.shortcut(
            type: shortcut.type,
            userInfo: shortcut.userInfo,
            context: resolveContext(context)
        )
    }
}

extension ShortcutDeeplink where ShortcutUserInfo: Decodable {

    public static func shortcut(
        _ shortcut: UIApplicationShortcutItem,
        userInfoDecoder: ShortcutDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyShortcutDeeplink? {
        let decodedUserInfo: ShortcutUserInfo?

        do {
            decodedUserInfo = try shortcut.userInfo.map { userInfo in
                try userInfoDecoder.decode(
                    ShortcutUserInfo.self,
                    from: userInfo
                )
            }
        } catch {
            throw DeeplinkDecodingError(
                underlyingError: error,
                trigger: self
            )
        }

        return try Self.shortcut(
            type: shortcut.type,
            userInfo: decodedUserInfo,
            context: resolveContext(context)
        )
    }
}
#endif
