#if canImport(UIKit)
import UIKit

public struct ScreenStackPopModifier: ScreenStackModifier {

    public let predicate: ScreenStackPopPredicate

    public var description: String {
        "Pop \(predicate)"
    }

    public init(predicate: ScreenStackPopPredicate) {
        self.predicate = predicate
    }

    public func perform(
        in stack: [UIViewController],
        navigation: ScreenNavigation
    ) throws -> [UIViewController] {
        guard let stackIndex = predicate.containerIndex(in: stack) else {
            throw ScreenContainerNotFoundError(
                type: UIViewController.self,
                for: self
            )
        }

        return Array(stack.prefix(through: stackIndex))
    }
}

extension ScreenThenable where Then: UINavigationController {

    public func pop(
        to predicate: ScreenStackPopPredicate,
        animation: ScreenStackAnimation? = .default
    ) -> Self {
        setStack(
            modifier: ScreenStackPopModifier(predicate: predicate),
            animation: animation
        )
    }

    public func pop(animation: ScreenStackAnimation? = .default) -> Self {
        pop(to: .previous)
    }

    public func popToRoot(animation: ScreenStackAnimation? = .default) -> Self {
        pop(to: .root)
    }
}

#endif
