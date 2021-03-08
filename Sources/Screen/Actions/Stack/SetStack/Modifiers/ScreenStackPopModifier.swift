#if canImport(UIKit)
import UIKit

public struct ScreenStackPopModifier: ScreenStackModifier {

    public var description: String {
        "Pop"
    }

    public init() { }

    public func perform(
        in stack: [UIViewController],
        navigation: ScreenNavigation
    ) throws -> [UIViewController] {
        stack.dropLast()
    }
}

extension ScreenRoute where Container: UINavigationController {

    public func pop(
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) -> Self {
        setStack(
            modifier: ScreenStackPopModifier(),
            animation: animation,
            separated: separated
        )
    }
}
#endif
