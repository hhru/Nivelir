import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// A predicate that allows to configure which containers will be observed by the observer.
///
/// Frequently used predicates are available through static properties and functions.
/// Predicates can be grouped using the static methods ``satisfiedAny(_:)`` and ``satisfiedAll(_:)``.
///
/// In the example below, the `ProleViewController` receives
/// new events only from the `AuthorizationObserver` type AND the list of containers specified in ``satisfiedAny(_:)``.
///
/// ```swift
/// class ProfileViewController: UIViewController {
///     let sceenNavigator: ScreenNavigator
///
///     override func viewDidLoad() {
///         super.viewDidLoad()
///
///         screenNavigator.observeWeakly(
///             by: self,
///             where: .satisfiedAll(
///                 .type(AuthorizationObserver.self),
///                 .satisfiedAny(
///                     .presented(on: self),
///                     .pushed(after: self),
///                     .child(of: self),
///                     .visible(self)
///                 )
///             )
///         )
///     }
/// }
///
/// extension ProfileViewController: AuthorizationObserver {
///     func authorizationFinished(isAuthorized: Bool) {
///         // Handle authorization update
///     }
/// }
/// ```
///
/// - SeeAlso: ``ScreenObserver``
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

    /// Observing and receiving notifications from all sources throughout the application.
    public static var any: Self {
        Self { _, _, _ in
            true
        }
    }

    /// Observe and receive notifications from sources
    /// matching one of the conditions specified in the `predicates` parameter.
    ///
    /// - Parameter predicates: A set of predicates.
    /// - Returns: A new instance of the predicate with an updated filter.
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

    /// Observe and receive notifications from sources
    /// matching all the conditions specified in the `predicates` parameter.
    ///
    /// - Parameter predicates: A set of predicates.
    /// - Returns: A new instance of the predicate with an updated filter.
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

    /// Observing and receiving notifications from sources by observer `type`.
    /// - Parameter type: The type of observer to filter by.
    /// - Returns: A new instance of the predicate with an updated filter.
    public static func type<Observer>(_ type: Observer.Type) -> Self {
        Self { observer, _, _ in
            observer is Observer
        }
    }

    /// Observing and receiving notifications from a specific `screen`.
    /// - Note: The container of `ScreenObservation` must
    ///  implement `ScreenKeyedContainer` to compare containers by `screenKey`.
    /// - Parameter screen: The screen to be observed.
    /// - Returns: A new instance of the predicate with an updated filter.
    public static func screen<T: Screen>(_ screen: T) -> Self where T.Observer: ScreenObserver {
        Self { _, container, _ in
            guard let container = container as? ScreenKeyedContainer else {
                return false
            }

            return container.screenKey == screen.key
        }
    }

    /// Observe and receive notifications if `container` is visible.
    /// - Parameter container: The container being checked for visibility.
    /// - Returns: A new instance of the predicate with an updated filter.
    public static func visible(
        _ container: ScreenVisibleContainer
    ) -> Self {
        Self { _, _, _ in
            container.isVisible
        }
    }

    #if canImport(UIKit)
    /// Observe and receive notifications from the screen shown modally.
    /// - Parameters:
    ///   - presentingContainer: The container that presented the container modally.
    ///   - recursively: If `true`, all modal screens presented on top of the `presentingContainer` will be observed.
    ///   Otherwise only one modal container will be observed.
    /// - Returns: A new instance of the predicate with an updated filter.
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

    /// Observing and receiving notifications from the children container.
    /// - Parameters:
    ///   - parentContainer: The parent view controller of the recipient.
    ///   - recursively: If `true`, all children after `parentContainer` will be observed.
    ///   Otherwise only the children of the `parentContainer` will be observed.
    /// - Returns: A new instance of the predicate with an updated filter.
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

    /// Observe and receive notifications from the containers specified in `stack`.
    /// - Parameters:
    ///   - stack: An array of `UIViewController` containers to be observed.
    ///   - recursively: If `true`, it will iterate over each container specified in `stack`.
    ///   Otherwise, only the containers specified in `stack` are observed.
    /// - Returns: A new instance of the predicate with an updated filter.
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

    /// Observe and receive notifications from containers in the navigation stack.
    /// - Parameters:
    ///   - stackContainer: The `UINavigationController` stack to be observed.
    ///   - recursively: If `true`, it will iterate over each container in the navigation stack.
    ///   Otherwise, only the containers in the navigation stack will be observed.
    /// - Returns: A new instance of the predicate with an updated filter.
    public static func pushed(
        into stackContainer: UINavigationController,
        recursively: Bool = true
    ) -> Self {
        Self { observer, container, iterator in
            pushed(into: stackContainer.viewControllers, recursively: recursively).filterObserver(
                observer,
                for: container,
                using: iterator
            )
        }
    }

    /// Observe and receive notifications from a container
    /// in the navigation stack pushed after the specified `pushingContainer`.
    ///
    /// - Parameters:
    ///   - pushingContainer: Container in the navigation stack, after which there will be an observation.
    ///   - recursively: If `true`, all containers pushed after the specified `pushingContainer` are observed.
    ///   Otherwise, only one container pushed after the specified `pushingContainer` is observed.
    /// - Returns: A new instance of the predicate with an updated filter.
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
