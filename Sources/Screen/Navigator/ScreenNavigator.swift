#if canImport(UIKit)
import UIKit

public final class ScreenNavigator {

    public typealias Completion = (Result<Void, Error>) -> Void

    private let windowProvider: ScreenWindowProvider
    private let builder: ScreenBuilder
    private let iterator: ScreenIterator
    private let logger: ScreenLogger?

    public init(
        windowProvider: ScreenWindowProvider,
        builder: ScreenBuilder = DefaultScreenBuilder(),
        iterator: ScreenIterator = DefaultScreenIterator(),
        logger: ScreenLogger? = DefaultScreenLogger()
    ) {
        self.windowProvider = windowProvider
        self.builder = builder
        self.iterator = iterator
        self.logger = logger
    }

    public convenience init(
        window: UIWindow,
        interceptors: [ScreenInterceptor],
        iterator: ScreenIterator = DefaultScreenIterator(),
        logger: ScreenLogger? = DefaultScreenLogger()
    ) {
        self.init(
            windowProvider: ScreenCustomWindowProvider(window: window),
            builder: DefaultScreenBuilder(interceptors: interceptors),
            iterator: iterator,
            logger: logger
        )
    }

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

    public func buildScreen<New: Screen>(
        _ screen: New,
        completion: @escaping (_ result: Result<New.Container, Error>) -> Void
    ) {
        builder.buildScreen(
            screen,
            navigator: self,
            completion: completion
        )
    }

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

    public func logInfo(_ info: @autoclosure () -> String) {
        logger?.info(info())
    }

    public func logError(_ error: @autoclosure () -> Error) {
        logger?.error(error())
    }
}
#else
public final class ScreenNavigator { }
#endif
