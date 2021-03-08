import UIKit

public protocol ScreenNavigator {

    typealias Completion = (Result<Void, Error>) -> Void

    func perform<Action: ScreenAction>(
        action: Action,
        completion: Completion?
    ) where Action.Container == UIWindow
}
