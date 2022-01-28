import Foundation

public protocol URLDeeplink: Deeplink, AnyURLDeeplink {

    associatedtype URLQuery

    static func url(
        scheme: String,
        host: String,
        path: [String],
        query: URLQuery?
    ) -> Self?

    static func url(_ url: URL, query: URLQuery?) -> Self?
}

extension URLDeeplink {

    public static func url(_ url: URL, query: URLQuery?) -> Self? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }

        guard let scheme = components.scheme else {
            return nil
        }

        guard let host = components.host else {
            return nil
        }

        let path = components
            .path
            .components(separatedBy: "/")
            .dropFirst()

        return .url(
            scheme: scheme,
            host: host,
            path: Array(path),
            query: query
        )
    }
}

extension URLDeeplink where URLQuery == Void {

    public static func url(_ url: URL, queryDecoder: URLDeeplinkQueryDecoder) -> AnyURLDeeplink? {
        Self.url(url, query: Void())
    }
}

extension URLDeeplink where URLQuery == String {

    public static func url(_ url: URL, queryDecoder: URLDeeplinkQueryDecoder) -> AnyURLDeeplink? {
        Self.url(url, query: url.query)
    }
}

extension URLDeeplink where URLQuery: Decodable {

    public static func url(_ url: URL, queryDecoder: URLDeeplinkQueryDecoder) -> AnyURLDeeplink? {
        do {
            let query = try url.query.map { query in
                try queryDecoder.decode(URLQuery.self, from: query)
            }

            return Self.url(url, query: query)
        } catch {
            return nil
        }
    }
}
