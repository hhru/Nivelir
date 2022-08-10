#if canImport(UIKit) && os(iOS)
import UIKit

/// Erased type of ``ShortcutDeeplink`` protocol.
///
/// - SeeAlso: ``ShortcutDeeplink``
/// - SeeAlso: ``DeeplinkManager``
public protocol AnyShortcutDeeplink: AnyDeeplink {

    /// Options for decoding `userInfo` from shortcut item.
    ///
    /// Implement this method if you want to change the data decoding strategies from `userInfo` of shortcut item.
    /// To review the default options, see ``ShortcutDeeplinkUserInfoOptions``.
    ///
    /// - Parameter context: Additional context for creating ``ShortcutDeeplinkUserInfoOptions``.
    /// Must match the context type of ``ShortcutDeeplink/ShortcutContext``.
    ///
    /// - Returns: Returns new options for decoding `userInfo` from shortcut item.
    static func shortcutUserInfoOptions(
        context: Any?
    ) throws -> ShortcutDeeplinkUserInfoOptions

    /// Creating a deep link from a shortcut item.
    /// - Parameters:
    ///   - shortcut: An application shortcut item, also called a *Home screen dynamic quick action*,
    ///   that specifies a user-initiated action for your app.
    ///   - userInfoDecoder: Decoder for decoding dictionary from `userInfo`.
    ///   - context: Additional context for checking and creating ``ShortcutDeeplink``.
    ///   Must match the context type of ``ShortcutDeeplink/ShortcutContext``.
    /// - Returns: Returns a new instance of ``ShortcutDeeplink`` that performs navigation.
    /// Otherwise `nil` if the deep link cannot be handled.
    static func shortcut(
        _ shortcut: UIApplicationShortcutItem,
        userInfoDecoder: ShortcutDeeplinkUserInfoDecoder,
        context: Any?
    ) throws -> AnyShortcutDeeplink?
}
#endif
