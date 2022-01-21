import Foundation

public protocol AnyURLDeeplink: AnyDeeplink {

    static func url(
        _ url: URL,
        queryDecoder: URLDeeplinkQueryDecoder
    ) -> AnyURLDeeplink?
}
