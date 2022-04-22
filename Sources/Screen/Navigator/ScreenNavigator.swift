#if canImport(UIKit)
import UIKit
#else
import Foundation
#endif

public final class ScreenNavigator {

    public typealias Completion = (Result<Void, Error>) -> Void

    #if canImport(UIKit)
    private let windowProvider: ScreenWindowProvider
    #endif

    private let observatory: ScreenObservatory
    private let iterator: ScreenIterator
    private let logger: ScreenLogger?

    #if canImport(UIKit)
    public var window: UIWindow? {
        windowProvider.window
    }

    public var topContainer: UIViewController? {
        window.flatMap { window in
            topContainer(in: window) { $0 is UIViewController } as? UIViewController
        }
    }

    public var topStackContainer: UINavigationController? {
        window.flatMap { window in
            topContainer(in: window) { $0 is UINavigationController } as? UINavigationController
        }
    }

    public var topTabsContainer: UITabBarController? {
        window.flatMap { window in
            topContainer(in: window) { $0 is UITabBarController } as? UITabBarController
        }
    }

    public init(
        windowProvider: ScreenWindowProvider = ScreenKeyWindowProvider(),
        observatory: ScreenObservatory = DefaultScreenObservatory(),
        iterator: ScreenIterator = DefaultScreenIterator(),
        logger: ScreenLogger? = DefaultScreenLogger()
    ) {
        self.windowProvider = windowProvider
        self.observatory = observatory
        self.iterator = iterator
        self.logger = logger
    }

    public init(
        window: UIWindow,
        observatory: ScreenObservatory = DefaultScreenObservatory(),
        iterator: ScreenIterator = DefaultScreenIterator(),
        logger: ScreenLogger? = DefaultScreenLogger()
    ) {
        self.windowProvider = ScreenCustomWindowProvider(window: window)
        self.observatory = observatory
        self.iterator = iterator
        self.logger = logger
    }
    #else
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

    public func registerObserver(
        _ observer: AnyObject,
        for target: ScreenObservationTarget
    ) {
        observatory.registerObserver(observer, for: target)
    }

    public func registerObserver<T: Screen>(
        _ observer: T.Observer,
        for screen: T
    ) where T.Observer: AnyObject {
        observatory.registerObserver(observer, for: screen)
    }

    public func unregisterObserver(
        _ observer: AnyObject,
        for target: ScreenObservationTarget
    ) {
        observatory.unregisterObserver(observer, for: target)
    }

    public func unregisterObserver<T: Screen>(
        _ observer: T.Observer,
        for screen: T
    ) where T.Observer: AnyObject {
        observatory.unregisterObserver(observer, for: screen)
    }

    public func unregisterObserver(_ observer: AnyObject) {
        observatory.unregisterObserver(observer)
    }

    public func observation<Observer>(
        of type: Observer.Type,
        for target: ScreenObservationTarget
    ) -> ScreenObservation<Observer> {
        observatory.observation(of: type, for: target)
    }

    public func observation<T: Screen>(for screen: T) -> ScreenObservation<T.Observer> {
        observatory.observation(for: screen)
    }

    // MARK: - Iterator

    public func iterate(
        from container: ScreenContainer,
        while predicate: ScreenIterationPredicate
    ) -> ScreenContainer? {
        iterator.iterate(from: container, while: predicate)
    }

    public func firstContainer(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer? {
        iterator.firstContainer(in: container, where: predicate)
    }

    public func lastContainer(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer? {
        iterator.lastContainer(in: container, where: predicate)
    }

    public func topContainer(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer? {
        iterator.topContainer(in: container, where: predicate)
    }

    // MARK: - Logger

    public func logInfo(_ info: @autoclosure () -> String) {
        logger?.info(info())
    }

    public func logError(_ error: @autoclosure () -> Error) {
        logger?.error(error())
    }
}
