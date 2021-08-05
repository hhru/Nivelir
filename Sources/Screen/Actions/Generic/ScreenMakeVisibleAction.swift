#if canImport(UIKit)
import UIKit

public struct ScreenMakeVisibleAction<Container: UIViewController>: ScreenAction {

    public typealias Output = Void

    public let stackAnimation: ScreenStackAnimation?
    public let tabsAnimation: ScreenTabAnimation?
    public let dissmissAnimated: Bool

    public init(
        stackAnimation: ScreenStackAnimation? = .default,
        tabsAnimation: ScreenTabAnimation? = nil,
        dissmissAnimated: Bool = true
    ) {
        self.stackAnimation = stackAnimation
        self.tabsAnimation = tabsAnimation
        self.dissmissAnimated = dissmissAnimated
    }

    private func showContainer(_ container: UIViewController) throws -> ScreenRootRoute<Container> {
        guard let parent = container.parent else {
            return .initial
        }

        switch parent {
        case let stackContainer as UINavigationController:
            return try showContainer(stackContainer)
                .from(stackContainer)
                .pop(to: .container(container), animation: stackAnimation)
                .route()

        case let tabsContainer as UITabBarController:
            return try showContainer(tabsContainer)
                .from(tabsContainer)
                .selectTab(with: .container(container), animation: tabsAnimation)
                .route()

        default:
            throw ScreenContainerNotSupportedError(container: parent, for: self)
        }
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        do {
            let route = ScreenModalRoute
                .from(container)
                .dismiss(animated: dissmissAnimated)
                .then(try showContainer(container))

            ScreenNavigateAction(actions: route.actions).perform(
                container: container,
                navigator: navigator,
                completion: completion
            )
        } catch {
            completion(.failure(error))
        }
    }
}

extension ScreenThenable where Current: UIViewController {

    public func makeVisible(
        stackAnimation: ScreenStackAnimation? = .default,
        tabsAnimation: ScreenTabAnimation? = nil,
        dissmissAnimated: Bool = true
    ) -> Self {
        then(
            ScreenMakeVisibleAction<Current>(
                stackAnimation: stackAnimation,
                tabsAnimation: tabsAnimation,
                dissmissAnimated: dissmissAnimated
            )
        )
    }
}
#endif
