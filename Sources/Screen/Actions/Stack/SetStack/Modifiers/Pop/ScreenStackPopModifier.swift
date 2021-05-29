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
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let stackIndex = predicate.containerIndex(in: stack) else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        completion(.success(Array(stack.prefix(through: stackIndex))))
    }
}

extension ScreenThenable where Then: UINavigationController {

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
            separated: separated
        )
    }

    public func popToRoot(
        animation: ScreenStackAnimation? = .default,
        separated: Bool = false
    ) -> Self {
        pop(
            to: .root,
            separated: separated
        )
    }
}

#endif
