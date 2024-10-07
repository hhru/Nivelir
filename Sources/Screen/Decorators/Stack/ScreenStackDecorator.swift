#if canImport(UIKit)
import UIKit

/// Replaces the view controllers currently managed by the navigation controller with the specified screens.
/// Sets the `viewControllers` property for a container with type `UINavigationController`.
public struct ScreenStackDecorator<Container: UINavigationController>: ScreenDecorator {

    public let stack: [AnyModalScreen]

    public var payload: Any? {
        nil
    }

    public let description: String

    public init(stack: [AnyModalScreen]) {
        self.stack = stack
        description = "StackDecorator"
    }

    public func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Container where Wrapped.Container == Container {
        let container = screen.build(navigator: navigator)

        container.viewControllers = stack.map { screen in
            screen.build(navigator: navigator)
        }

        return container
    }
}

extension Screen where Container: UINavigationController {

    /// Replaces the view controllers currently managed by the navigation controller with the specified screens.
    /// Sets the `viewControllers` property for a container with type `UINavigationController`.
    /// - Parameter stack: The screens to place in the stack.
    /// The front-to-back order of the screens in this array represents
    /// the new bottom-to-top order of the controllers in the navigation stack.
    /// Thus, the last item added to the array becomes the top item of the navigation stack.
    /// - Returns: New `Screen` with replaced `viewControllers` in container.
    @MainActor
    public func withStack(_ stack: [AnyModalScreen]) -> AnyScreen<Container> {
        decorated(by: ScreenStackDecorator(stack: stack))
    }

    /// Replaces the view controllers currently managed by the navigation controller with the specified screens.
    /// Sets the `viewControllers` property for a container with type `UINavigationController`.
    /// - Parameter stack: The screens to place in the stack.
    /// The front-to-back order of the screens in this array represents
    /// the new bottom-to-top order of the controllers in the navigation stack.
    /// Thus, the last item added to the array becomes the top item of the navigation stack.
    /// - Returns: New `Screen` with replaced `viewControllers` in container.
    @MainActor
    public func withStack(_ stack: AnyModalScreen...) -> AnyScreen<Container> {
        withStack(stack)
    }

    /// Replaces the view controllers currently managed by the navigation controller with the specified screen.
    /// Sets the `viewControllers` property for a container with type `UINavigationController`.
    /// - Parameter screen: The screen to place in the stack as root.
    /// - Returns: New `Screen` with replaced `viewControllers` in container.
    @MainActor
    public func withStack<T: Screen>(
        _ screen: T
    ) -> AnyScreen<Container> where T.Container: UIViewController {
        withStack(screen.eraseToAnyModalScreen())
    }

    // swiftlint:disable generic_type_name

    /// Replaces the view controllers currently managed by the navigation controller with the specified screen.
    /// Sets the `viewControllers` property for a container with type `UINavigationController`.
    /// - Parameters:
    ///   - screen0: The screen to place in the stack as root.
    ///   - screen1: The screen to place in the stack as top.
    /// - Returns: New `Screen` with replaced `viewControllers` in container.
    @MainActor
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

    /// Replaces the view controllers currently managed by the navigation controller with the specified screen.
    /// Sets the `viewControllers` property for a container with type `UINavigationController`.
    /// - Parameters:
    ///   - screen0: The screen to place in the stack as root.
    ///   - screen1: The screen to place in the stack as second after the root.
    ///   - screen2: The screen to place in the stack as top.
    /// - Returns: New `Screen` with replaced `viewControllers` in container.
    @MainActor
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

    /// Replaces the view controllers currently managed by the navigation controller with the specified screen.
    /// Sets the `viewControllers` property for a container with type `UINavigationController`.
    /// - Parameters:
    ///   - screen0: The screen to place in the stack as root.
    ///   - screen1: The screen to place in the stack as second after the root.
    ///   - screen2: The screen to place in the stack as third after the root.
    ///   - screen3: The screen to place in the stack as top.
    /// - Returns: New `Screen` with replaced `viewControllers` in container.
    @MainActor
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

    /// Replaces the view controllers currently managed by the navigation controller with the specified screen.
    /// Sets the `viewControllers` property for a container with type `UINavigationController`.
    /// - Parameters:
    ///   - screen0: The screen to place in the stack as root.
    ///   - screen1: The screen to place in the stack as second after the root.
    ///   - screen2: The screen to place in the stack as third after the root.
    ///   - screen3: The screen to place in the stack as fourth after the root.
    ///   - screen4: The screen to place in the stack as top.
    /// - Returns: New `Screen` with replaced `viewControllers` in container.
    @MainActor
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

    // swiftlint:enable generic_type_name
}
#endif
