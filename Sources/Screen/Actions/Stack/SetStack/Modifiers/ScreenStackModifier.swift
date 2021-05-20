#if canImport(UIKit)
import UIKit

public protocol ScreenStackModifier: CustomStringConvertible {
    typealias Completion = (_ result: Result<[UIViewController], Error>) -> Void

    func perform(
        in stack: [UIViewController],
        navigation: ScreenNavigation,
        completion: @escaping Completion
    )
}
#endif
