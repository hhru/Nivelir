#if canImport(UIKit)
import UIKit

public struct ScreenStackPopModifier: ScreenStackModifier {

    public let predicate: ScreenStackPopPredicate

    public let description: String

    public init(predicate: ScreenStackPopPredicate) {
        self.predicate = predicate
        description = "Pop \(predicate)"
    }

    public func perform(
        stack: [UIViewController],
        navigator: ScreenNavigator
    ) throws -> [UIViewController] {
        guard let stackIndex = predicate.containerIndex(in: stack) else {
            throw ScreenContainerNotFoundError(type: UIViewController.self, for: self)
        }

        let stackCount = stackIndex + 1

        guard stackCount >= .zero, stackCount <= stack.count else {
            throw ScreenContainerNotFoundError(type: UIViewController.self, for: self)
        }

        return Array(stack.prefix(stackCount))
    }
}

extension ScreenThenable where Current: UINavigationController {

    public func pop(
        to predicate: ScreenStackPopPredicate,
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) -> Self {
        setStack(
            modifier: ScreenStackPopModifier(predicate: predicate),
            animation: animation,
            separated: separated
        )
    }

    public func pop(
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) -> Self {
        pop(
            to: .previous,
            animation: animation,
            separated: separated
        )
    }

    public func popToRoot(
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) -> Self {
        pop(
            to: .root,
            animation: animation,
            separated: separated
        )
    }
}
#endif
