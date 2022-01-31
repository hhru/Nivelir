import Foundation

public protocol URLDeeplink: Deeplink, AnyURLDeeplink {

    associatedtype URLQuery
    associatedtype Context

    static func urlQueryOptions(
        context: Context?
    ) -> URLDeeplinkQueryOptions

    static func url(
        scheme: String,
        host: String,
        path: [String],
        query: URLQuery?,
        context: Context?
    ) throws -> Self?

    static func url(
        _ url: URL,
        query: URLQuery?,
        context: Context?
    ) throws -> Self?
}

extension URLDeeplink {

    public static func urlQueryOptions(
        context: Context?
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
        context: Context?
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

extension URLDeeplink where URLQuery == Void {

    public static func url(
        _ url: URL,
        queryDecoder: URLDeeplinkQueryDecoder,
        context: Any?
    ) throws -> AnyURLDeeplink? {
        try Self.url(
            url,
            query: Void(),
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
