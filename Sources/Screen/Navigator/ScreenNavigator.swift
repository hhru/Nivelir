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

    private let contextManager: ScreenContextManager
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
        contextManager: ScreenContextManager = DefaultScreenContextManager(),
        iterator: ScreenIterator = DefaultScreenIterator(),
        logger: ScreenLogger? = DefaultScreenLogger()
    ) {
        self.windowProvider = windowProvider
        self.contextManager = contextManager
        self.iterator = iterator
        self.logger = logger
    }

    public init(
        window: UIWindow,
        contextManager: ScreenContextManager = DefaultScreenContextManager(),
        iterator: ScreenIterator = DefaultScreenIterator(),
        logger: ScreenLogger? = DefaultScreenLogger()
    ) {
        self.windowProvider = ScreenCustomWindowProvider(window: window)
        self.contextManager = contextManager
        self.iterator = iterator
        self.logger = logger
    }
    #else
    public init(
        contextManager: ScreenContextManager,
        iterator: ScreenIterator,
        logger: ScreenLogger?
    ) {
        self.contextManager = contextManager
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

    // MARK: - Context

    public func registerWeakContext(_ context: AnyObject, for key: ScreenKey) {
        contextManager.registerWeakContext(context, for: key)
    }

    public func registerWeakContext<T: Screen>(_ context: AnyObject, for screen: T) {
        contextManager.registerWeakContext(context, for: screen)
    }

    public func registerWeakContext(_ context: AnyObject) {
        contextManager.registerWeakContext(context)
    }

    public func registerContext(_ context: AnyObject, for key: ScreenKey) {
        contextManager.registerContext(context, for: key)
    }

    public func registerContext<T: Screen>(_ context: AnyObject, for screen: T) {
        contextManager.registerContext(context, for: screen)
    }

    public func registerContext(_ context: AnyObject) {
        contextManager.registerContext(context)
    }

    public func unregisterContext(_ context: AnyObject, for key: ScreenKey) {
        contextManager.unregisterContext(context, for: key)
    }

    public func unregisterContext<T: Screen>(_ context: AnyObject, for screen: T) {
        contextManager.unregisterContext(context, for: screen)
    }

    public func unregisterContext(_ context: AnyObject) {
        contextManager.unregisterContext(context)
    }

    public func context<Context>(of type: Context.Type, for key: ScreenKey) -> ScreenContext<Context> {
        contextManager.context(of: type, for: key)
    }

    public func context<T: Screen>(for screen: T) -> ScreenContext<T.Context> {
        contextManager.context(for: screen)
    }

    public func context<Context>(of type: Context.Type) -> ScreenContext<Context> {
        contextManager.context(of: type)
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
