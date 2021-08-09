#if canImport(UIKit)
import UIKit

public struct ScreenStackClearModifier: ScreenStackModifier {

    public var description: String {
        "Clear"
    }

    public init() { }

    public func perform(
        stack: [UIViewController],
        navigator: ScreenNavigator
    ) -> [UIViewController] {
        []
    }
}

extension ScreenThenable where Current: UINavigationController {

    public func clear(animation: ScreenStackAnimation? = .default) -> Self {
        setStack(
            modifier: ScreenStackClearModifier(),
            animation: animation
        )
    }
}
#endif
