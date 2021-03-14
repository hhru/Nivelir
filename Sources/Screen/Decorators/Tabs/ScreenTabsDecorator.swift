#if canImport(UIKit)
import UIKit

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

    public func withTabs(_ tabs: [AnyModalScreen]) -> AnyScreen<Container> {
        decorated(by: ScreenTabsDecorator(tabs: tabs))
    }

    public func withTabs(_ tabs: AnyModalScreen...) -> AnyScreen<Container> {
        withTabs(tabs)
    }

    public func withTabs<T: Screen>(
        _ screen: T
    ) -> AnyScreen<Container> where T.Container: UIViewController {
        withTabs(screen.eraseToAnyModalScreen())
    }

    // swiftlint:disable:next generic_type_name
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

    // swiftlint:disable:next generic_type_name
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

    // swiftlint:disable:next generic_type_name
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

    // swiftlint:disable:next generic_type_name
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
}
#endif
