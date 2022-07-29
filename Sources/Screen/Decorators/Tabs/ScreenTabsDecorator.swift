#if canImport(UIKit)
import UIKit

/// Sets the root view controllers of the tab bar controller.
/// Sets the `viewControllers` property for a container with type `UITabBarController`.
public struct ScreenTabsDecorator<Container: UITabBarController>: ScreenDecorator {

    public let tabs: [AnyModalScreen]

    public var payload: Any? {
        nil
    }

    public var description: String {
        "TabsDecorator"
    }

    public init(tabs: [AnyModalScreen], selected: Int = 0) {
        self.tabs = tabs
    }

    public func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Container where Wrapped.Container == Container {
        let container = screen.build(navigator: navigator)

        container.viewControllers = tabs.map { screen in
            screen.build(navigator: navigator)
        }

        return container
    }
}

extension Screen where Container: UITabBarController {

    /// Sets the root view controllers of the tab bar controller.
    /// Sets the `viewControllers` property for a container with type `UITabBarController`.
    /// - Parameter tabs: The array of screens to display in the tab bar interface.
    /// The order of the screens in this array corresponds to the display order in the tab bar,
    /// with the screen at index 0 representing the left-most tab,
    /// the screen at index 1 the next tab to the right, and so on.
    /// - Returns: New `Screen` with updated `viewControllers` in container.
    public func withTabs(_ tabs: [AnyModalScreen]) -> AnyScreen<Container> {
        decorated(by: ScreenTabsDecorator(tabs: tabs))
    }

    /// Sets the root view controllers of the tab bar controller.
    /// Sets the `viewControllers` property for a container with type `UITabBarController`.
    /// - Parameter tabs: The array of screens to display in the tab bar interface.
    /// The order of the screens in this array corresponds to the display order in the tab bar,
    /// with the screen at index 0 representing the left-most tab,
    /// the screen at index 1 the next tab to the right, and so on.
    /// - Returns: New `Screen` with updated `viewControllers` in container.
    public func withTabs(_ tabs: AnyModalScreen...) -> AnyScreen<Container> {
        withTabs(tabs)
    }

    /// Sets the root view controller of the tab bar controller.
    /// Sets the `viewControllers` property for a container with type `UITabBarController`.
    /// - Parameter screen: The screen to display in the tab bar interface.
    /// - Returns: New `Screen` with updated `viewControllers` in container.
    public func withTabs<T: Screen>(
        _ screen: T
    ) -> AnyScreen<Container> where T.Container: UIViewController {
        withTabs(screen.eraseToAnyModalScreen())
    }

    // swiftlint:disable generic_type_name

    /// Sets the root view controller of the tab bar controller.
    /// Sets the `viewControllers` property for a container with type `UITabBarController`.
    /// - Parameters:
    ///   - screen0: The screen representing the left-most tab.
    ///   - screen1: The screen of the next tab after `screen0`.
    /// - Returns: New `Screen` with updated `viewControllers` in container.
    public func withTabs<T0: Screen, T1: Screen>(
        _ screen0: T0,
        _ screen1: T1
    ) -> AnyScreen<Container> where
        T0.Container: UIViewController,
        T1.Container: UIViewController {
        withTabs(
            screen0.eraseToAnyModalScreen(),
            screen1.eraseToAnyModalScreen()
        )
    }

    /// Sets the root view controller of the tab bar controller.
    /// Sets the `viewControllers` property for a container with type `UITabBarController`.
    /// - Parameters:
    ///   - screen0: The screen representing the left-most tab.
    ///   - screen1: The screen of the next tab after `screen0`.
    ///   - screen2: The screen of the next tab after `screen1`.
    /// - Returns: New `Screen` with updated `viewControllers` in container.
    public func withTabs<T0: Screen, T1: Screen, T2: Screen>(
        _ screen0: T0,
        _ screen1: T1,
        _ screen2: T2
    ) -> AnyScreen<Container> where
        T0.Container: UIViewController,
        T1.Container: UIViewController,
        T2.Container: UIViewController {
        withTabs(
            screen0.eraseToAnyModalScreen(),
            screen1.eraseToAnyModalScreen(),
            screen2.eraseToAnyModalScreen()
        )
    }

    /// Sets the root view controller of the tab bar controller.
    /// Sets the `viewControllers` property for a container with type `UITabBarController`.
    /// - Parameters:
    ///   - screen0: The screen representing the left-most tab.
    ///   - screen1: The screen of the next tab after `screen0`.
    ///   - screen2: The screen of the next tab after `screen1`.
    ///   - screen3: The screen of the next tab after `screen2`.
    /// - Returns: New `Screen` with updated `viewControllers` in container.
    public func withTabs<T0: Screen, T1: Screen, T2: Screen, T3: Screen>(
        _ screen0: T0,
        _ screen1: T1,
        _ screen2: T2,
        _ screen3: T3
    ) -> AnyScreen<Container> where
        T0.Container: UIViewController,
        T1.Container: UIViewController,
        T2.Container: UIViewController,
        T3.Container: UIViewController {
        withTabs(
            screen0.eraseToAnyModalScreen(),
            screen1.eraseToAnyModalScreen(),
            screen2.eraseToAnyModalScreen(),
            screen3.eraseToAnyModalScreen()
        )
    }

    /// Sets the root view controller of the tab bar controller.
    /// Sets the `viewControllers` property for a container with type `UITabBarController`.
    /// - Parameters:
    ///   - screen0: The screen representing the left-most tab.
    ///   - screen1: The screen of the next tab after `screen0`.
    ///   - screen2: The screen of the next tab after `screen1`.
    ///   - screen3: The screen of the next tab after `screen2`.
    ///   - screen4: The screen of the next tab after `screen3`.
    /// - Returns: New `Screen` with updated `viewControllers` in container.
    public func withTabs<T0: Screen, T1: Screen, T2: Screen, T3: Screen, T4: Screen>(
        _ screen0: T0,
        _ screen1: T1,
        _ screen2: T2,
        _ screen3: T3,
        _ screen4: T4
    ) -> AnyScreen<Container> where
        T0.Container: UIViewController,
        T1.Container: UIViewController,
        T2.Container: UIViewController,
        T3.Container: UIViewController,
        T4.Container: UIViewController {
        withTabs(
            screen0.eraseToAnyModalScreen(),
            screen1.eraseToAnyModalScreen(),
            screen2.eraseToAnyModalScreen(),
            screen3.eraseToAnyModalScreen(),
            screen4.eraseToAnyModalScreen()
        )
    }

    // swiftlint:enable generic_type_name
}
#endif
