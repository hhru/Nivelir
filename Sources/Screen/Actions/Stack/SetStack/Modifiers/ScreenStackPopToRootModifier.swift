import UIKit

public struct ScreenStackPopToRootModifier: ScreenStackModifier {

    public var description: String {
        "Pop to root"
    }

    public init() { }

    public func perform(
        in stack: [UIViewController],
        navigation: ScreenNavigation
    ) throws -> [UIViewController] {
        Array(stack.prefix(1))
    }
}

extension ScreenRoute where Container: UINavigationController {

    public func popToRoot(
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) -> Self {
        setStack(
            modifier: ScreenStackPopToRootModifier(),
            animation: animation,
            separated: separated
        )
    }
}
