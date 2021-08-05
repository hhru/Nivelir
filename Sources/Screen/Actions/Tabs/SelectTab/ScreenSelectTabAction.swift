#if canImport(UIKit)
import UIKit

public struct ScreenSelectTabAction<
    Container: UITabBarController,
    Output: ScreenContainer
>: ScreenAction {

    public let predicate: ScreenTabPredicate
    public let animation: ScreenTabAnimation?

    public init(
        predicate: ScreenTabPredicate,
        animation: ScreenTabAnimation? = nil
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
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Selecting tab of \(Output.self) type in \(type(of: container)) with \(predicate)")

        let selectedTab = container.selectedTab

        guard let newSelectedTabIndex = predicate.tabIndex(in: container.viewControllers ?? []) else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let newSelectedTab = container.viewControllers?[safe: newSelectedTabIndex] else {
            return completion(.containerNotFound(type: UIViewController.self, for: self))
        }

        guard let output = newSelectedTab as? Output else {
            return completion(.containerTypeMismatch(newSelectedTab, type: Output.self, for: self))
        }

        animateIfNeeded(
            container: container,
            from: selectedTab,
            to: newSelectedTab
        ) {
            container.selectedIndex = newSelectedTabIndex

            DispatchQueue.main.async {
                completion(.success(output))
            }
        }
    }
}

extension ScreenThenable where Current: UITabBarController {

    public func selectTab<Output: UIViewController, Route: ScreenThenable>(
        of type: Output.Type = Output.self,
        with predicate: ScreenTabPredicate,
        animation: ScreenTabAnimation? = nil,
        route: Route
    ) -> Self where Route.Root == Output {
        fold(
            action: ScreenSelectTabAction<Current, Output>(
                predicate: predicate,
                animation: animation
            ),
            nested: route
        )
    }

    public func selectTab<Output: UIViewController>(
        of type: Output.Type = Output.self,
        with predicate: ScreenTabPredicate,
        animation: ScreenTabAnimation? = nil,
        route: (_ route: ScreenRootRoute<Output>) -> ScreenRouteConvertible = { $0 }
    ) -> Self {
        selectTab(
            of: type,
            with: predicate,
            animation: animation,
            route: route(.initial).route()
        )
    }
}
#endif
