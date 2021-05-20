import Foundation

public protocol ScreenInterceptor {
    typealias Completion = (_ result: Result<Void, Error>) -> Void

    func interceptScreen<New: Screen>(
        _ screen: New,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    )
}
