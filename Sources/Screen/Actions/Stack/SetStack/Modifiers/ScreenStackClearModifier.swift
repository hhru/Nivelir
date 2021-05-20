#if canImport(UIKit)
import UIKit

public struct ScreenStackClearModifier: ScreenStackModifier {

    public var description: String {
        "Clear"
    }

    public init() { }

    public func perform(
        in stack: [UIViewController],
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        completion(.success([]))
    }
}

extension ScreenThenable where Then: UINavigationController {

    public func clear(animation: ScreenStackAnimation? = .default) -> Self {
        setStack(
            modifier: ScreenStackClearModifier(),
            animation: animation
        )
    }
}
#endif
