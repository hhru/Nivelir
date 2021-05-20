#if canImport(UIKit)
import UIKit

public protocol ScreenStackModifier: CustomStringConvertible {
    typealias Completion = (_ result: Result<[UIViewController], Error>) -> Void

    func perform(
        in stack: [UIViewController],
        navigator: ScreenNavigator,
        completion: @escaping Completion
    )
}
#endif
