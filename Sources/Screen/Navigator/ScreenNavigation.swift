import Foundation

public struct ScreenNavigation {

    private let navigator: ScreenNavigator
    private let builder: ScreenBuilder
    private let iterator: ScreenIterator
    private let logger: ScreenLogger?

    internal init(
        navigator: ScreenNavigator,
        builder: ScreenBuilder,
        iterator: ScreenIterator,
        logger: ScreenLogger?
    ) {
        self.navigator = navigator
        self.builder = builder
        self.iterator = iterator
        self.logger = logger
    }

    public func buildScreen<New: Screen>(
        _ screen: New,
        completion: @escaping (_ result: Result<New.Container, Error>) -> Void
    ) {
        builder.buildScreen(
            screen,
            navigator: navigator,
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
