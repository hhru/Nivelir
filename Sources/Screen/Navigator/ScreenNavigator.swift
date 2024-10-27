#if canImport(UIKit)
import UIKit
#else
import Foundation
#endif

/// The navigator is a facade and combines the features of Nivelir for easy navigation.
///
/// With `ScreenNavigator` you can:
/// - Find the current top container
/// - Perform navigation actions
/// - Observe screens
/// - Search for a container with a predicate
/// - Log navigation actions
///
/// Each `UIWindow` in an application must have its own `ScreenNavigator`.
/// To do this, the navigator can be initialized in different ways for an iOS application:
///
/// 1) Implement its own `ScreenWindowProvider`, which returns `UIWindow`.
/// The default implementation is `ScreenKeyWindowProvider`, which returns the first found key `UIWindow`.
///
/// 2) Pass an instance of `UIWindow` explicitly.
///
/// Next, the search for screens and performing all actions will be using this `UIWindow` instance.
///
/// Also in the initializer you can pass the implementation:
/// - `ScreenObservatory` to implement its observatory for storing screen observers.
/// - `ScreenIterator` to implement its iterator over containers for searching.
/// - `ScreenLogger` to implement its navigation logger output. You can pass `nil` to disable logging.
///
/// - SeeAlso: `ScreenWindowProvider`
/// - SeeAlso: `ScreenObservatory`
/// - SeeAlso: `ScreenIterator`
/// - SeeAlso: `ScreenLogger`
@MainActor
public final class ScreenNavigator {

    /// Closure with the result of the navigation action.
    public typealias Completion = (Result<Void, Error>) -> Void

    #if canImport(UIKit)
    private let windowProvider: ScreenWindowProvider
    #endif

    private let observatory: ScreenObservatory
    private let iterator: ScreenIterator
    private let logger: ScreenLogger?

    #if canImport(UIKit)
    /// The current window that the navigator uses to perform actions and search for containers.
    public var window: UIWindow? {
        windowProvider.window
    }

    /// The current top and visible container of type `UIViewController`.
    /// Returns `nil` if no such container is found.
    public var topContainer: UIViewController? {
        window.flatMap { window in
            topContainer(in: window) { $0 is UIViewController } as? UIViewController
        }
    }

    /// The current top and visible container of type `UINavigationController`.
    /// Returns `nil` if no such container is found.
    public var topStackContainer: UINavigationController? {
        window.flatMap { window in
            topContainer(in: window) { $0 is UINavigationController } as? UINavigationController
        }
    }

    /// The current top and visible container of type `UITabBarController`.
    /// Returns `nil` if no such container is found.
    public var topTabsContainer: UITabBarController? {
        window.flatMap { window in
            topContainer(in: window) { $0 is UITabBarController } as? UITabBarController
        }
    }

    /// Initializing an instance of `ScreenNavigator`.
    /// Each `UIWindow` in the application must have its own `ScreenNavigator`.
    /// - Parameters:
    ///   - windowProvider: Implementations of a provider returning an `UIWindow`
    ///   which will be used for navigating and searching containers.
    ///   - observatory: Implementations of an observatory for storing screen observers.
    ///   - iterator: Implementation of a container iterator for searching.
    ///   - logger: Implementation of the navigation log output. Pass `nil` to disable logging.
    public init(
        windowProvider: ScreenWindowProvider? = nil,
        observatory: ScreenObservatory? = nil,
        iterator: ScreenIterator? = nil,
        logger: ScreenLogger? = nil
    ) {
        self.windowProvider = windowProvider ?? ScreenKeyWindowProvider()
        self.observatory = observatory ?? DefaultScreenObservatory()
        self.iterator = iterator ?? DefaultScreenIterator()
        self.logger = logger ?? DefaultScreenLogger()
    }

    /// Initializing an instance of `ScreenNavigator`.
    /// Each `UIWindow` in the application must have its own `ScreenNavigator`.
    /// - Parameters:
    ///   - window: `UIWindow` which will be used for navigating and searching containers.
    ///   - observatory: Implementations of an observatory for storing screen observers.
    ///   - iterator: Implementation of a container iterator for searching.
    ///   - logger: Implementation of the navigation log output. Pass `nil` to disable logging.
    public init(
        window: UIWindow,
        observatory: ScreenObservatory? = nil,
        iterator: ScreenIterator? = nil,
        logger: ScreenLogger? = nil
    ) {
        self.windowProvider = ScreenCustomWindowProvider(window: window)
        self.observatory = observatory ?? DefaultScreenObservatory()
        self.iterator = iterator ?? DefaultScreenIterator()
        self.logger = logger ?? DefaultScreenLogger()
    }
#else
    /// Initializing an instance of `ScreenNavigator`.
    /// - Parameters:
    ///   - observatory: Implementations of an observatory for storing screen observers.
    ///   - iterator: Implementation of a container iterator for searching.
    ///   - logger: Implementation of the navigation log output. Pass `nil` to disable logging.
    public init(
        observatory: ScreenObservatory,
        iterator: ScreenIterator,
        logger: ScreenLogger?
    ) {
        self.observatory = observatory
        self.iterator = iterator
        self.logger = logger
    }
    #endif

    // MARK: - Actions

    #if canImport(UIKit)
    private func perform<Action: ScreenAction>(
        action: Action,
        completion: @escaping Action.Completion
    ) where Action.Container == UIWindow {
        guard let window = windowProvider.window else {
            return completion(.containerNotFound(type: UIWindow.self, for: self))
        }

        action.perform(
            container: window,
            navigator: self,
            completion: completion
        )
    }

    /// Performing a navigation action with a container of type `UIWindow`.
    /// The action will be performed on the `UIWindow` instance passed in the initializer.
    /// - Parameters:
    ///   - action: Navigation action to perform.
    ///   - completion: Closure with the result of the navigation action.
    public func perform<Action: ScreenAction>(
        action: Action,
        completion: Completion?
    ) where Action.Container == UIWindow {
        perform(action: action) { [weak self] result in
            switch result {
            case .success:
                completion?(.success)

            case let .failure(error):
                self?.logger?.error(error)
                completion?(.failure(error))
            }
        }
    }
    #endif

    // MARK: - Observatory

    /// Observing containers by an observer.
    /// The observer will receive new notifications until the end of its life cycle.
    /// After the observer is deinited, it will stop receiving new notifications.
    /// - Parameters:
    ///   - observer: A class that implements the `ScreenObserver` protocol that will receive new notifications.
    ///   - predicate: Predicate allows you to limit from which sources new notifications are received.
    ///   By specifying `.any` the observer will receive notifications from all sources.
    public func observeWeakly(
        by observer: ScreenObserver,
        where predicate: ScreenObserverPredicate
    ) {
        observatory.observeWeakly(by: observer, where: predicate)
    }

    /// Observing containers by an observer.
    /// - Parameters:
    ///   - observer: A class that implements the `ScreenObserver` protocol that will receive new notifications.
    ///
    ///   - predicate: Predicate allows you to limit from which sources new notifications are received.
    ///   By specifying `.any` the observer will receive notifications from all sources.
    ///
    ///   - weakly: Sets how the observer is captured in memory.
    ///   If set to `false`, the observer will receive new notifications and is captured by the **strong reference**
    ///   until the `cancel()` or `deinit` method of the `ScreenObserverToken` is called,
    ///   which returns this function.
    ///   If `true` is set, the observer will be captured by the **weak reference**
    ///    and will stop receiving notifications after observer is deinited or cancellation with the token.
    ///
    /// - Returns: A token that allows to cancel a subscription.
    /// The subscription is automatically canceled when the token is deinited.
    public func observe(
        by observer: ScreenObserver,
        where predicate: ScreenObserverPredicate,
        weakly: Bool
    ) -> ScreenObserverToken {
        observatory.observe(by: observer, where: predicate, weakly: weakly)
    }

    /// Observing containers by an observer.
    /// Еhe observer will receive new notifications and is captured by the **strong reference**
    /// until the `cancel()` or `deinit` method of the `ScreenObserverToken` is called
    /// - Parameters:
    ///   - observer: A class that implements the `ScreenObserver` protocol that will receive new notifications.
    ///   - predicate: Predicate allows you to limit from which sources new notifications are received.
    ///   By specifying `.any` the observer will receive notifications from all sources.
    /// - Returns: A token that allows to cancel a subscription.
    /// The subscription is automatically canceled when the token is deinited.
    public func observe(
        by observer: ScreenObserver,
        where predicate: ScreenObserverPredicate
    ) -> ScreenObserverToken {
        observatory.observe(by: observer, where: predicate)
    }

    /// Creates a new `ScreenObservation`, which sends notifications to subscribed observers.
    /// - Parameter type: The type of observer that will receive notifications.
    /// - Returns: New `ScreenObservation'.
    public func observation<Observer>(of type: Observer.Type) -> ScreenObservation<Observer> {
        observatory.observation(of: type, iterator: iterator)
    }

    // MARK: - Iterator

    /// Iterate through containers starting from a given `container` as long as the `predicate` condition holds.
    /// This method can be used to search for container using a custom `predicate`.
    /// - Parameters:
    ///   - container: The container from which the iteration starts.
    ///   - predicate: A predicate that determines whether to continue iterating or stop.
    /// - Returns: The container on which the predicate has stopped iterating.
    /// If the predicate has not stopped iterating until all containers have iterated, then this value will be `nil`.
    public func iterate(
        from container: ScreenContainer,
        while predicate: ScreenIterationPredicate
    ) -> ScreenContainer? {
        iterator.iterate(from: container, while: predicate)
    }

    /// Returns the first container that satisfies the given `predicate`,
    /// starting the iteration from the given `container`.
    /// - Parameters:
    ///   - container: The container from which the iteration starts.
    ///   - predicate: A closure that takes a container as its argument
    ///   and returns a Boolean value indicating whether the element is a match.
    /// - Returns: The first container that satisfies `predicate`,
    /// or `nil` if there is no container that satisfies `predicate`.
    public func firstContainer(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer? {
        iterator.firstContainer(in: container, where: predicate)
    }

    /// Returns the last container that satisfies the given `predicate`,
    /// starting the iteration from the given `container`.
    /// - Parameters:
    ///   - container: The container from which the iteration starts.
    ///   - predicate: A closure that takes a container as its argument
    ///   and returns a Boolean value indicating whether the element is a match.
    /// - Returns: The last container that satisfies `predicate`,
    /// or `nil` if there is no container that satisfies predicate.
    public func lastContainer(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer? {
        iterator.lastContainer(in: container, where: predicate)
    }

    /// Returns the top (visible) container that satisfies the given `predicate`,
    /// starting the iteration from the given `container`.
    /// - Parameters:
    ///   - container: The container from which the iteration starts.
    ///   - predicate: A closure that takes a container as its argument
    ///   and returns a Boolean value indicating whether the element is a match.
    /// - Returns: The top (visible) container that satisfies `predicate`,
    /// or `nil` if there is no container that satisfies predicate.
    public func topContainer(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer? {
        iterator.topContainer(in: container, where: predicate)
    }

    // MARK: - Logger

    /// Writes an informative message to the log.
    /// - Parameter info: The string that the logger writes to the log.
    public func logInfo(_ info: @autoclosure () -> String) {
        logger?.info(info())
    }

    /// Writes information about an error to the log.
    /// - Parameter error: The string that the logger writes to the log.
    public func logError(_ error: @autoclosure () -> Error) {
        logger?.error(error())
    }
}
