import Foundation

/// The type of ``Deeplink`` that is handled from the URL.
///
/// This type allows you to handle the ``Deeplink`` from URL, which comes via function parameters.
///
/// Nivelir can decode query part of URL depending on the type of ``URLQuery``.
/// For example, if ``URLQuery`` implements the `Decodable` protocol,
/// then there is no need to manually parse
/// the query part of URL – check for keys and cast values to the correct type.
/// Instead, the query part of URL will be automatically decoded
/// into an instance of the ``URLQuery`` type (like with JSON).
/// The options for decoding are set via ``urlQueryOptions(context:)-2mjrm``.
///
/// You may need additional context to check and create an instance.
/// For example, it may be a service factory from which additional data can be obtained.
/// The associated type ``URLContext`` is used for this purpose.
public protocol URLDeeplink: Deeplink, AnyURLDeeplink {

    /// The type of the query of the URL.
    associatedtype URLQuery

    /// Type of context for checking and creating a ``Deeplink`` instance.
    associatedtype URLContext

    /// Options for decoding query part from URL.
    ///
    /// Implement this method if you want to change the data decoding strategies from URL query part.
    /// To review the default options, see ``URLDeeplinkQueryOptions``.
    ///
    /// - Parameter context: Additional context for creating ``URLDeeplinkQueryOptions``.
    /// - Returns: Returns new options for decoding query part from URL.
    static func urlQueryOptions(
        context: URLContext
    ) -> URLDeeplinkQueryOptions

    /// Creating a ``Deeplink`` from a URL components.
    /// - Parameters:
    ///   - scheme: The scheme subcomponent of the URL.
    ///   - host: The host subcomponent.
    ///   - path: The path subcomponent.
    ///   - query: The query of the URL if the URL conforms to RFC 1808 (the most common form of URL), otherwise nil.
    ///   - context: Additional context for checking and creating instance.
    /// - Returns: Returns a new instance of ``URLDeeplink`` that performs navigation.
    /// Otherwise `nil` if the ``Deeplink`` cannot be handled.
    static func url(
        scheme: String?,
        host: String?,
        path: [String],
        query: URLQuery?,
        context: URLContext
    ) throws -> Self?

    /// Creating a ``Deeplink`` from a URL.
    /// - Parameters:
    ///   - url: A URL Scheme or Universal Link from `UIApplicationDelegate` or `UIWindowSceneDelegate`.
    ///   - query: The query of the URL if the URL conforms to RFC 1808 (the most common form of URL), otherwise nil.
    ///   - context: Additional context for checking and creating instance.
    /// - Returns: Returns a new instance of ``URLDeeplink`` that performs navigation.
    /// Otherwise `nil` if the ``Deeplink`` cannot be handled.
    static func url(
        _ url: URL,
        query: URLQuery?,
        context: URLContext
    ) throws -> Self?
}

// MARK: - Context resolving

extension URLDeeplink where URLContext: Nullable {

    private static func resolveContext(_ context: Any?) throws -> URLContext {
        guard let context else {
            return .none
        }

        guard let urlContext = context as? URLContext else {
            throw DeeplinkInvalidContextError(
                context: context,
                type: URLContext.self,
                for: self
            )
        }

        return urlContext
    }
}

extension URLDeeplink {

    private static func resolveContext(_ context: Any?) throws -> URLContext {
        guard let urlContext = context as? URLContext else {
            throw DeeplinkInvalidContextError(
                context: context,
                type: URLContext.self,
                for: self
            )
        }

        return urlContext
    }
}

// MARK: - Default implementation

extension URLDeeplink {

    /// Options for decoding query part from URL.
    ///
    /// Implement this method if you want to change the data decoding strategies from URL query part.
    /// To review the default options, see ``URLDeeplinkQueryOptions``.
    ///
    /// - Parameter context: Additional context for creating ``URLDeeplinkQueryOptions``.
    /// - Returns: Returns new options for decoding query part from URL.
    public static func urlQueryOptions(
        context: URLContext
    ) -> URLDeeplinkQueryOptions {
        URLDeeplinkQueryOptions()
    }

    /// Options for decoding query part from URL.
    ///
    /// Implement this method if you want to change the data decoding strategies from URL query part.
    /// To review the default options, see ``URLDeeplinkQueryOptions``.
    ///
    /// - Parameter context: Additional context for creating ``URLDeeplinkQueryOptions``.
    /// Must match the context type of ``URLDeeplink/URLContext``.
    ///
    /// - Returns: Returns new options for decoding query part from URL.
    public static func urlQueryOptions(
        context: Any?
    ) throws -> URLDeeplinkQueryOptions {
        urlQueryOptions(context: try resolveContext(context))
    }

    public static func url(
        _ url: URL,
        query: URLQuery?,
        context: URLContext
    ) throws -> Self? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw URLDeeplinkInvalidComponentsError(url: url, for: self)
        }

        var rawPath = components.path

        if rawPath.hasPrefix(String.urlPathSeparator) {
            rawPath.removeFirst(String.urlPathSeparator.count)
        }

        if rawPath.hasSuffix(String.urlPathSeparator) {
            rawPath.removeLast(String.urlPathSeparator.count)
        }

        let path = rawPath.components(separatedBy: String.urlPathSeparator)

        return try Self.url(
            scheme: components.scheme,
            host: components.host,
            path: path,
            query: query,
            context: context
        )
    }
}

extension URLDeeplink where URLQuery == Any {

    public static func url(
        _ url: URL,
        queryDecoder: URLDeeplinkQueryDecoder,
        context: Any?
    ) throws -> AnyURLDeeplink? {
        try Self.url(
            url,
            query: url.query,
            context: resolveContext(context)
        )
    }
}

extension URLDeeplink where URLQuery == String {

    public static func url(
        _ url: URL,
        queryDecoder: URLDeeplinkQueryDecoder,
        context: Any?
    ) throws -> AnyURLDeeplink? {
        try Self.url(
            url,
            query: url.query,
            context: resolveContext(context)
        )
    }
}

extension URLDeeplink where URLQuery: Decodable {

    public static func url(
        _ url: URL,
        queryDecoder: URLDeeplinkQueryDecoder,
        context: Any?
    ) throws -> AnyURLDeeplink? {
        let decodedQuery: URLQuery?

        do {
            decodedQuery = try url.query.map { query in
                try queryDecoder.decode(
                    URLQuery.self,
                    from: query
                )
            }
        } catch {
            throw DeeplinkDecodingError(
                underlyingError: error,
                trigger: self
            )
        }

        return try Self.url(
            url,
            query: decodedQuery,
            context: resolveContext(context)
        )
    }
}
