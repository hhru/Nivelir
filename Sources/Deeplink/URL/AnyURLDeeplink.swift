import Foundation

public protocol AnyURLDeeplink: AnyDeeplink {

    static func urlQueryOptions(
        context: Any?
    ) throws -> URLDeeplinkQueryOptions

    static func url(
        _ url: URL,
        queryDecoder: URLDeeplinkQueryDecoder,
        context: Any?
    ) throws -> AnyURLDeeplink?
}
