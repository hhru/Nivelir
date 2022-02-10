import Foundation

public protocol URLDeeplink: Deeplink, AnyURLDeeplink {

    associatedtype URLQuery
    associatedtype URLContext

    static func urlQueryOptions(
        context: URLContext
    ) -> URLDeeplinkQueryOptions

    static func url(
        scheme: String,
        host: String,
        path: [String],
        query: URLQuery?,
        context: URLContext
    ) throws -> Self?

    static func url(
        _ url: URL,
        query: URLQuery?,
        context: URLContext
    ) throws -> Self?
}

// MARK: - Context resolving

extension URLDeeplink where URLContext: Nullable {

    private static func resolveContext(_ context: Any?) throws -> URLContext {
        guard let context = context else {
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

    public static func urlQueryOptions(
        context: URLContext
    ) -> URLDeeplinkQueryOptions {
        URLDeeplinkQueryOptions()
    }

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

        guard let scheme = components.scheme else {
            throw URLDeeplinkInvalidSchemeError(url: url, for: self)
        }

        guard let host = components.host else {
            throw URLDeeplinkInvalidHostError(url: url, for: self)
        }

        let path = components
            .path
            .components(separatedBy: String.urlPathSeparator)
            .dropFirst()

        return try Self.url(
            scheme: scheme,
            host: host,
            path: Array(path),
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
