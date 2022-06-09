import Foundation

#if canImport(UIKit)
import UIKit
#endif

public struct ScreenObserverPredicate {

    public typealias Filter = (
        _ observer: ScreenObserver,
        _ container: ScreenContainer?,
        _ iterator: ScreenIterator
    ) -> Bool

    private let filter: Filter

    public init(filter: @escaping Filter) {
        self.filter = filter
    }

    internal func filterObserver(
        _ observer: ScreenObserver,
        for container: ScreenContainer?,
        using iterator: ScreenIterator
    ) -> Bool {
        filter(observer, container, iterator)
    }
}

extension ScreenObserverPredicate {

    public static var any: Self {
        Self { _, _, _ in
            true
        }
    }

    public static func satisfiedAny(_ predicates: ScreenObserverPredicate...) -> Self {
        Self { observer, container, iterator in
            predicates.contains { predicate in
                predicate.filterObserver(
                    observer,
                    for: container,
                    using: iterator
                )
            }
        }
    }

    public static func satisfiedAll(_ predicates: ScreenObserverPredicate...) -> Self {
        Self { observer, container, iterator in
            predicates.allSatisfy { predicate in
                predicate.filterObserver(
                    observer,
                    for: container,
                    using: iterator
                )
            }
        }
    }

    public static func type<Observer>(_ type: Observer.Type) -> Self {
        Self { observer, _, _ in
            observer is Observer
        }
    }

    public static func screen<T: Screen>(_ screen: T) -> Self where T.Observer: ScreenObserver {
        Self { _, container, _ in
            guard let container = container as? ScreenKeyedContainer else {
                return false
            }

            return container.screenKey == screen.key
        }
    }

    public static func visible(
        _ container: ScreenVisibleContainer
    ) -> Self {
        Self { _, _, _ in
            container.isVisible
        }
    }

    #if canImport(UIKit)
    public static func presented(
        on presentingContainer: UIViewController,
        recursively: Bool = true
    ) -> Self {
        Self { _, container, iterator in
            guard let container = container as? UIViewController else {
                return false
            }

            guard presentingContainer.isVisible || (presentingContainer.parent == nil) else {
                return false
            }

            guard let presentedContainer = presentingContainer.presented else {
                return false
            }

            if presentedContainer == container {
                return true
            } else if !recursively {
                return false
            }

            return iterator.firstContainer(in: presentedContainer) { nextContainer in
                container == nextContainer as? UIViewController
            } != nil
        }
    }

    public static func child(
        of parentContainer: UIViewController,
        recursively: Bool = true
    ) -> Self {
        Self { _, container, iterator in
            guard let container = container as? UIViewController else {
                return false
            }

            let children = parentContainer.children

            if children.contains(container) {
                return true
            } else if !recursively {
                return false
            }

            return children.contains { childContainer in
                iterator.firstContainer(in: childContainer) { nextContainer in
                    container == nextContainer as? UIViewController
                } != nil
            }
        }
    }

    public static func pushed(
        into stack: [UIViewController],
        recursively: Bool = true
    ) -> Self {
        Self { _, container, iterator in
            guard let container = container as? UIViewController else {
                return false
            }

            if stack.contains(container) {
                return true
            } else if !recursively {
                return false
            }

            return stack.contains { pushedContainer in
                iterator.firstContainer(in: pushedContainer) { nextContainer in
                    container == nextContainer as? UIViewController
                } != nil
            }
        }
    }

    public static func pushed(
        into stackContainer: UINavigationController,
        recursively: Bool = true
    ) -> Self {
        Self { observer, container, iterator in
            pushed(into: stackContainer.viewControllers).filterObserver(
                observer,
                for: container,
                using: iterator
            )
        }
    }

    public static func pushed(
        after pushingContainer: UIViewController,
        recursively: Bool = true
    ) -> Self {
        Self { observer, container, iterator in
            var pushingContainer = pushingContainer

            while let parentContainer = pushingContainer.parent, parentContainer != pushingContainer.stack {
                pushingContainer = parentContainer
            }

            guard let stack = pushingContainer.stack?.viewControllers else {
                return false
            }

            guard let stackIndex = stack.firstIndex(of: pushingContainer) else {
                return false
            }

            let stackNextIndex = stackIndex + 1

            if stack[safe: stackNextIndex] == container as? UIViewController {
                return true
            } else if !recursively {
                return false
            }

            return pushed(into: Array(stack.suffix(from: stackNextIndex))).filterObserver(
                observer,
                for: container,
                using: iterator
            )
        }
    }
    #endif
}
