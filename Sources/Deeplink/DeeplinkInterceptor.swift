import Foundation

public protocol DeeplinkInterceptor {

    typealias Completion = (Result<Void, Error>) -> Void

    func interceptDeeplink(
        _ deeplink: AnyDeeplink,
        of type: DeeplinkType,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    )
}
