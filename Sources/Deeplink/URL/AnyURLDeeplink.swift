import Foundation

/// Erased type of ``URLDeeplink`` protocol.
///
/// - SeeAlso: ``URLDeeplink``
/// - SeeAlso: ``DeeplinkManager``
public protocol AnyURLDeeplink: AnyDeeplink {

    /// Options for decoding query part from URL.
    ///
    /// Implement this method if you want to change the data decoding strategies from URL query part.
    /// To review the default options, see ``URLDeeplinkQueryOptions``.
    ///
    /// - Parameter context: Additional context for creating ``URLDeeplinkQueryOptions``.
    /// Must match the context type of ``URLDeeplink/URLContext``.
    ///
    /// - Returns: Returns new options for decoding query part from URL.
    static func urlQueryOptions(
        context: Any?
    ) throws -> URLDeeplinkQueryOptions

    /// Creating a deep link from a URL.
    ///
    /// - Parameters:
    ///   - url: A URL (Universal Resource Locator).
    ///   URL Scheme or Universal Link from `UIApplicationDelegate` or `UIWindowSceneDelegate`.
    ///   - queryDecoder: Decoder for decoding query part from `url`.
    ///   - context: Additional context for checking and creating ``URLDeeplink``.
    ///   Must match the context type of ``URLDeeplink/URLContext``.
    /// - Returns: Returns a new instance of ``URLDeeplink`` that performs navigation.
    /// Otherwise `nil` if the deep link cannot be handled.
    static func url(
        _ url: URL,
        queryDecoder: URLDeeplinkQueryDecoder,
        context: Any?
    ) throws -> AnyURLDeeplink?
}
