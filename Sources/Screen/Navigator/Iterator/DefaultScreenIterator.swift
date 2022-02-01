#if canImport(UIKit)
import UIKit

public final class DefaultScreenIterator: ScreenIterator {

    public init() { }

    private func iterateLocally(
        in containers: [ScreenContainer],
        while predicate: ScreenIterationPredicate,
        fallingBackTo fallbackContainer: ScreenContainer?
    ) -> ScreenIterationResult {
        var recentContainer = fallbackContainer

        for container in containers {
            switch predicate.checkContainer(container) {
            case let .shouldContinue(suitableContainer):
                recentContainer = suitableContainer ?? recentContainer

            case let .shouldStop(suitableContainer):
                return .shouldStop(suitableContainer: suitableContainer)
            }

            let result = iterateLocally(
                in: container,
                while: predicate,
                fallingBackTo: recentContainer
            )

            switch result {
            case let .shouldContinue(suitableContainer):
                recentContainer = suitableContainer ?? recentContainer

            case let .shouldStop(suitableContainer):
                return .shouldStop(suitableContainer: suitableContainer)
            }
        }

        return .shouldContinue(suitableContainer: recentContainer)
    }

    private func iterateLocally(
        in container: ScreenContainer,
        while predicate: ScreenIterationPredicate,
        fallingBackTo fallbackContainer: ScreenContainer?
    ) -> ScreenIterationResult {
        let localContainers: [ScreenContainer]

        if let container = container as? ScreenIterableContainer {
            localContainers = container.nestedContainers
        } else {
            localContainers = []
        }

        return iterateLocally(
            in: localContainers,
            while: predicate,
            fallingBackTo: fallbackContainer
        )
    }

    private func iterate(
        from container: UIViewController,
        while predicate: ScreenIterationPredicate,
        fallingBackTo fallbackContainer: ScreenContainer?
    ) -> ScreenContainer? {
        let result = iterateLocally(
            in: container,
            while: predicate,
            fallingBackTo: fallbackContainer
        )

        let localRecentContainer: ScreenContainer?

        switch result {
        case let .shouldContinue(suitableContainer):
            localRecentContainer = suitableContainer ?? fallbackContainer

        case let .shouldStop(suitableContainer):
            return suitableContainer
        }

        guard let presentedContainer = container.presentedViewController else {
            return localRecentContainer
        }

        let recentContainer: ScreenContainer?

        switch predicate.checkContainer(presentedContainer) {
        case let .shouldContinue(suitableContainer):
            recentContainer = suitableContainer ?? localRecentContainer

        case let .shouldStop(suitableContainer):
            return suitableContainer
        }

        return iterate(
            from: presentedContainer,
            while: predicate,
            fallingBackTo: recentContainer
        )
    }

    private func iterate(
        from container: UIWindow,
        while predicate: ScreenIterationPredicate,
        fallingBackTo fallbackContainer: ScreenContainer?
    ) -> ScreenContainer? {
        guard let rootContainer = container.root else {
            return fallbackContainer
        }

        let recentContainer: ScreenContainer?

        switch predicate.checkContainer(rootContainer) {
        case let .shouldContinue(suitableContainer):
            recentContainer = suitableContainer ?? fallbackContainer

        case let .shouldStop(suitableContainer):
            return suitableContainer
        }

        return iterate(
            from: rootContainer,
            while: predicate,
            fallingBackTo: recentContainer
        )
    }

    public func iterate(
        from container: ScreenContainer,
        while predicate: ScreenIterationPredicate
    ) -> ScreenContainer? {
        let recentContainer: ScreenContainer?

        switch predicate.checkContainer(container) {
        case let .shouldContinue(suitableContainer):
            recentContainer = suitableContainer

        case let .shouldStop(suitableContainer):
            return suitableContainer
        }

        switch container {
        case let container as UIWindow:
            return iterate(
                from: container,
                while: predicate,
                fallingBackTo: recentContainer
            )

        case let container as UIViewController:
            return iterate(
                from: container,
                while: predicate,
                fallingBackTo: recentContainer
            )

        default:
            return recentContainer
        }
    }

    public func firstContainer(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer? {
        iterate(
            from: container,
            while: ScreenIterationPredicate { container in
                predicate(container)
                    ? .shouldStop(suitableContainer: container)
                    : .shouldContinue(suitableContainer: nil)
            }
        )
    }

    public func lastContainer(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer? {
        iterate(
            from: container,
            while: ScreenIterationPredicate { container in
                .shouldContinue(suitableContainer: predicate(container) ? container : nil)
            }
        )
    }

    public func topContainer(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer? {
        iterate(
            from: container,
            while: ScreenIterationPredicate { container in
                if let container = container as? ScreenVisibleContainer, container.isVisible {
                    return .shouldContinue(suitableContainer: predicate(container) ? container : nil)
                } else {
                    return .shouldContinue(suitableContainer: nil)
                }
            }
        )
    }
}
#endif
