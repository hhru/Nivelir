import Foundation

public protocol ScreenBuilder {
    func buildScreen<New: Screen>(
        _ screen: New,
        navigator: ScreenNavigator,
        completion: @escaping (_ result: Result<New.Container, Error>) -> Void
    )
}
