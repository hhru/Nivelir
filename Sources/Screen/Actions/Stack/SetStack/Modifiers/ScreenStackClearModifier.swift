#if canImport(UIKit)
import UIKit

public struct ScreenStackClearModifier: ScreenStackModifier {

    public let description: String

    public init() {
        description = "Clear"
    }

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
