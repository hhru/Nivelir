#if canImport(UIKit) && os(iOS)
import UIKit

/// The type of ``Deeplink`` that is handled from the Shortcuts App.
///
/// This type allows you to handle the ``Deeplink`` from the shortcut item data, which comes via function parameters.
///
/// Nivelir can decode `userInfo` depending on the type of ``ShortcutUserInfo``.
/// For example, if ``ShortcutUserInfo`` implements the `Decodable` protocol,
/// then there is no need to manually parse
/// the dictionary of `userInfo` – check for keys and cast values to the correct type.
/// Instead, the dictionary will be automatically decoded
/// into an instance of the ``ShortcutUserInfo`` type (like with JSON).
/// The options for decoding are set via ``shortcutUserInfoOptions(context:)-6vc5x``.
///
/// You may need additional context to check and create an instance.
/// For example, it may be a service factory from which additional data can be obtained.
/// The associated type ``ShortcutContext`` is used for this purpose.
public protocol ShortcutDeeplink: Deeplink, AnyShortcutDeeplink {

    /// The type of app-specific information that is provided for use when
    /// your application performs a quick action on the Home screen.
    associatedtype ShortcutUserInfo

    /// Type of context for checking and creating a ``Deeplink`` instance.
    associatedtype ShortcutContext

    /// Options for decoding `userInfo` from shortcut item.
    ///
    /// Implement this method if you want to change the data decoding strategies from `userInfo` of shortcut item.
    /// To review the default options, see ``ShortcutDeeplinkUserInfoOptions``.
    ///
    /// - Parameter context: Additional context for creating ``ShortcutDeeplinkUserInfoOptions``.
    /// - Returns: Returns new options for decoding `userInfo` from shortcut item.
    static func shortcutUserInfoOptions(
        context: ShortcutContext
    ) -> ShortcutDeeplinkUserInfoOptions

    /// Creating a ``Deeplink`` from a shortcut item type.
    /// - Parameters:
    ///   - type: A required, app-specific string that you employ to identify the type of quick action to perform.
    ///   - userInfo: Optional, app-specific information that provided for use
    ///   when your app performs the Home screen quick action.
    ///   - context: Additional context for checking and creating instance.
    /// - Returns: Returns a new instance of ``ShortcutDeeplink`` that performs navigation.
    /// Otherwise `nil` if the ``Deeplink`` cannot be handled.
    static func shortcut(
        type: String,
        userInfo: ShortcutUserInfo?,
        context: ShortcutContext
    ) throws -> Self?
}

// MARK: - Context resolving

extension ShortcutDeeplink where ShortcutContext: Nullable {

    private static func resolveContext(_ context: Any?) throws -> ShortcutContext {
        guard let context = context else {
            return .none
        }

        guard let shortcutContext = context as? ShortcutContext else {
            throw DeeplinkInvalidContextError(
                context: context,
                type: ShortcutContext.self,
                for: self
            )
        }

        return shortcutContext
    }
}

extension ShortcutDeeplink {

    private static func resolveContext(_ context: Any?) throws -> ShortcutContext {
        guard let shortcutContext = context as? ShortcutContext else {
            throw DeeplinkInvalidContextError(
                context: context,
                type: ShortcutContext.self,
                for: self
            )
        }

        return shortcutContext
    }
}

// MARK: - Default implementation

extension ShortcutDeeplink {

    /// Options for decoding `userInfo` from shortcut item.
    ///
    /// Implement this method if you want to change the data decoding strategies from `userInfo` of shortcut item.
    /// To review the default options, see ``ShortcutDeeplinkUserInfoOptions``.
    ///
    /// - Parameter context: Additional context for creating ``ShortcutDeeplinkUserInfoOptions``.
    /// - Returns: Returns new options for decoding `userInfo` from shortcut item.
    public static func shortcutUserInfoOptions(
        context: ShortcutContext
    ) -> ShortcutDeeplinkUserInfoOptions {
        ShortcutDeeplinkUserInfoOptions()
    }

    /// Options for decoding `userInfo` from shortcut item.
    ///
    /// Implement this method if you want to change the data decoding strategies from `userInfo` of shortcut item.
    /// To review the default options, see ``ShortcutDeeplinkUserInfoOptions``.
    ///
    /// - Parameter context: Additional context for creating ``ShortcutDeeplinkUserInfoOptions``.
    /// Must match the context type of ``ShortcutDeeplink/ShortcutContext``.
    ///
    /// - Returns: Returns new options for decoding `userInfo` from shortcut item.
    public static func shortcutUserInfoOptions(
        context: Any?
    ) throws -> ShortcutDeeplinkUserInfoOptions {
        shortcutUserInfoOptions(context: try resolveContext(context))
    }
}

extension ShortcutDeeplink where ShortcutUserInfo == Any {

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

extension ShortcutDeeplink where ShortcutUserInfo == [String: Any] {

    public static func shortcut(
        _ shortcut: UIApplicationShortcutItem,
        userInfoDecoder: ShortcutDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyShortcutDeeplink? {
        try Self.shortcut(
            type: shortcut.type,
            userInfo: shortcut.userInfo ?? [:],
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
