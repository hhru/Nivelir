import Foundation

public protocol DeeplinkInterceptor {

    typealias Completion = (Result<Void, Error>) -> Void

    func interceptDeeplink(
        _ deeplink: AnyDeeplink,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    )
}
