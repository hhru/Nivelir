#if canImport(UIKit)
import UIKit
#else
import Foundation
#endif

public protocol ScreenNavigator {
    typealias Completion = (Result<Void, Error>) -> Void

    #if canImport(UIKit)
    func perform<Action: ScreenAction>(
        action: Action,
        completion: Completion?
    ) where Action.Container == UIWindow
    #endif
}
