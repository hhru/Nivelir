import UIKit

public struct ScreenStackPopToModifier: ScreenStackModifier {

    public let predicate: ScreenStackPopToPredicate

    public var description: String {
        "Pop to screen"
    }

    public init(predicate: ScreenStackPopToPredicate) {
        self.predicate = predicate
    }

    public func perform(
        in stack: [UIViewController],
        navigation: ScreenNavigation
    ) throws -> [UIViewController] {
        guard let stackIndex = predicate(stack) else {
            throw ScreenContainerNotFoundError<UIViewController>(for: self)
        }

        return Array(stack.prefix(through: stackIndex))
    }
}

extension ScreenRoute where Container: UINavigationController {

    public func popTo(
        _ predicate: ScreenStackPopToPredicate,
        animation: ScreenStackAnimation? = .default
    ) -> Self {
        setStack(
            modifier: ScreenStackPopToModifier(predicate: predicate),
            animation: animation
        )
    }
}
