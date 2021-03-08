#if canImport(UIKit)
import UIKit

public final class DefaultScreenIterator: ScreenIterator {

    public init() { }

    private func iterateLocally(
        in containers: [UIViewController],
        while predicate: ScreenIterationPredicate,
        fallingBackTo fallbackContainer: ScreenContainer?
    ) -> ScreenIterationResult {
        var recentContainer = fallbackContainer

        for container in containers {
            switch predicate.checkContainer(container) {
            case let .shouldContinue(matchingContainer):
                recentContainer = matchingContainer ?? recentContainer

            case let .shouldStop(matchingContainer):
                return .shouldStop(matchingContainer: matchingContainer)
            }

            let result = iterateLocally(
                in: container,
                while: predicate,
                fallingBackTo: recentContainer
            )

            switch result {
            case let .shouldContinue(matchingContainer):
                recentContainer = matchingContainer ?? recentContainer

            case let .shouldStop(matchingContainer):
                return .shouldStop(matchingContainer: matchingContainer)
            }
        }

        return .shouldContinue(matchingContainer: recentContainer)
    }

    private func iterateLocally(
        in container: UIViewController,
        while predicate: ScreenIterationPredicate,
        fallingBackTo fallbackContainer: ScreenContainer?
    ) -> ScreenIterationResult {
        let localContainers: [UIViewController]

        switch container {
        case let stackContainer as UINavigationController:
            localContainers = stackContainer.viewControllers

        case let tabsContainer as UITabBarController:
            let tabContainers = tabsContainer.viewControllers ?? []

            localContainers = tabsContainer.selectedViewController.map { selectedContainer in
                tabContainers
                    .removingAll { $0 === selectedContainer }
                    .appending(selectedContainer)
            } ?? tabContainers

        default:
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
        case let .shouldContinue(matchingContainer):
            localRecentContainer = matchingContainer ?? fallbackContainer

        case let .shouldStop(matchingContainer):
            return matchingContainer
        }

        guard let presentedContainer = container.presentedViewController else {
            return localRecentContainer
        }

        let recentContainer: ScreenContainer?

        switch predicate.checkContainer(presentedContainer) {
        case let .shouldContinue(matchingContainer):
            recentContainer = matchingContainer ?? localRecentContainer

        case let .shouldStop(matchingContainer):
            return matchingContainer
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
        case let .shouldContinue(matchingContainer):
            recentContainer = matchingContainer ?? fallbackContainer

        case let .shouldStop(matchingContainer):
            return matchingContainer
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
        case let .shouldContinue(matchingContainer):
            recentContainer = matchingContainer

        case let .shouldStop(matchingContainer):
            return matchingContainer
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

    public func first(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer? {
        iterate(
            from: container,
            while: ScreenIterationPredicate { container in
                predicate(container)
                    ? .shouldStop(matchingContainer: container)
                    : .shouldContinue(matchingContainer: nil)
            }
        )
    }

    public func top(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer? {
        iterate(
            from: container,
            while: ScreenIterationPredicate { container in
                .shouldContinue(matchingContainer: predicate(container) ? container : nil)
            }
        )
    }
}
#endif
