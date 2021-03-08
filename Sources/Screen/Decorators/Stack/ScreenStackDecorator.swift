#if canImport(UIKit)
import UIKit

public struct ScreenStackDecorator<Container: UINavigationController>: ScreenDecorator {

    public let stack: [AnyModalScreen]

    public var payload: Any? {
        nil
    }

    public init(stack: [AnyModalScreen]) {
        self.stack = stack
    }

    public func buildDecorated<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator,
        associating payload: Any?
    ) -> Container where Wrapped.Container == Container {
        let container = screen.build(
            navigator: navigator,
            associating: payload
        )

        container.viewControllers = stack.map { screen in
            screen.build(navigator: navigator)
        }

        return container
    }
}

extension Screen where Container: UINavigationController {

    public func withStack(_ stack: [AnyModalScreen]) -> AnyScreen<Container> {
        decorated(by: ScreenStackDecorator(stack: stack))
    }

    public func withStack(_ stack: AnyModalScreen...) -> AnyScreen<Container> {
        withStack(stack)
    }

    public func withStack<T: Screen>(
        _ screen: T
    ) -> AnyScreen<Container> where T.Container: UIViewController {
        withStack(screen.eraseToAnyModalScreen())
    }

    // swiftlint:disable:next generic_type_name
    public func withStack<T0: Screen, T1: Screen>(
        _ screen0: T0,
        _ screen1: T1
    ) -> AnyScreen<Container> where
        T0.Container: UIViewController,
        T1.Container: UIViewController {
        withStack(
            screen0.eraseToAnyModalScreen(),
            screen1.eraseToAnyModalScreen()
        )
    }

    // swiftlint:disable:next generic_type_name
    public func withStack<T0: Screen, T1: Screen, T2: Screen>(
        _ screen0: T0,
        _ screen1: T1,
        _ screen2: T2
    ) -> AnyScreen<Container> where
        T0.Container: UIViewController,
        T1.Container: UIViewController,
        T2.Container: UIViewController {
        withStack(
            screen0.eraseToAnyModalScreen(),
            screen1.eraseToAnyModalScreen(),
            screen2.eraseToAnyModalScreen()
        )
    }

    // swiftlint:disable:next generic_type_name
    public func withStack<T0: Screen, T1: Screen, T2: Screen, T3: Screen>(
        _ screen0: T0,
        _ screen1: T1,
        _ screen2: T2,
        _ screen3: T3
    ) -> AnyScreen<Container> where
        T0.Container: UIViewController,
        T1.Container: UIViewController,
        T2.Container: UIViewController,
        T3.Container: UIViewController {
        withStack(
            screen0.eraseToAnyModalScreen(),
            screen1.eraseToAnyModalScreen(),
            screen2.eraseToAnyModalScreen(),
            screen3.eraseToAnyModalScreen()
        )
    }

    // swiftlint:disable:next generic_type_name
    public func withStack<T0: Screen, T1: Screen, T2: Screen, T3: Screen, T4: Screen>(
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
        withStack(
            screen0.eraseToAnyModalScreen(),
            screen1.eraseToAnyModalScreen(),
            screen2.eraseToAnyModalScreen(),
            screen3.eraseToAnyModalScreen(),
            screen4.eraseToAnyModalScreen()
        )
    }
}
#endif
