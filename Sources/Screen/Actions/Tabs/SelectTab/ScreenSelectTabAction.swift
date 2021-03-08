import UIKit

public struct ScreenSelectTabAction<
    Container: UITabBarController,
    Output: ScreenContainer
>: ScreenAction {

    public let predicate: ScreenSelectTabPredicate<Container>
    public let animation: ScreenSelectTabAnimation?

    public init(
        predicate: ScreenSelectTabPredicate<Container>,
        animation: ScreenSelectTabAnimation? = nil
    ) {
        self.predicate = predicate
        self.animation = animation
    }

    private func animateIfNeeded(
        container: Container,
        from selectedTab: UIViewController?,
        to newSelectedTab: UIViewController,
        completion: @escaping () -> Void
    ) {
        guard let animation = animation else {
            return completion()
        }

        guard let selectedTab = selectedTab, selectedTab !== newSelectedTab else {
            return completion()
        }

        animation.animate(
            container: container,
            from: selectedTab,
            to: newSelectedTab,
            completion: completion
        )
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        navigation.logger?.info("Selecting tab of \(Output.self) type in \(container)")

        let selectedTab = container.selectedTab

        guard let newSelectedTabIndex = predicate(container.viewControllers ?? []) else {
            return completion(.failure(ScreenContainerNotFoundError<UIViewController>(for: self)))
        }

        guard let newSelectedTab = container.viewControllers?[safe: newSelectedTabIndex] else {
            return completion(.failure(ScreenContainerNotFoundError<UIViewController>(for: self)))
        }

        animateIfNeeded(
            container: container,
            from: selectedTab,
            to: newSelectedTab
        ) {
            container.selectedIndex = newSelectedTabIndex

            guard let output = newSelectedTab as? Output else {
                return completion(.failure(ScreenInvalidContainerError<Output>(for: self)))
            }

            completion(.success(output))
        }
    }
}

extension ScreenRoute where Container: UITabBarController {

    public func selectTab<Output: UIViewController>(
        of type: Output.Type,
        with predicate: ScreenSelectTabPredicate<Container>,
        animation: ScreenSelectTabAnimation? = nil,
        route: ScreenRoute<Output>
    ) -> Self {
        join(
            action: ScreenSelectTabAction<Container, Output>(
                predicate: predicate,
                animation: animation
            ),
            route: route
        )
    }

    public func selectTab<Output: UIViewController>(
        of type: Output.Type,
        with predicate: ScreenSelectTabPredicate<Container>,
        animation: ScreenSelectTabAnimation? = nil,
        route: (_ route: ScreenRoute<Output>) -> ScreenRoute<Output> = { $0 }
    ) -> Self {
        selectTab(
            of: type,
            with: predicate,
            animation: animation,
            route: route(.initial)
        )
    }

    public func selectTab(
        with predicate: ScreenSelectTabPredicate<Container>,
        animation: ScreenSelectTabAnimation? = nil,
        route: ScreenModalRoute
    ) -> Self {
        selectTab(
            of: UIViewController.self,
            with: predicate,
            animation: animation,
            route: route
        )
    }

    public func selectTab(
        with predicate: ScreenSelectTabPredicate<Container>,
        animation: ScreenSelectTabAnimation? = nil,
        route: (_ route: ScreenModalRoute) -> ScreenModalRoute = { $0 }
    ) -> Self {
        selectTab(
            of: UIViewController.self,
            with: predicate,
            animation: animation,
            route: route
        )
    }
}
