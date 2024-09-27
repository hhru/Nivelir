#if canImport(UIKit)
import UIKit

/// Wraps `Screen` with a container of type `UIViewController` in the navigation controller as root.
public struct ScreenStackContainerDecorator<
    Container: UIViewController,
    Output: UINavigationController
>: ScreenDecorator {

    public var payload: Any? {
        nil
    }

    public let description: String

    public init() {
        description = "StackContainerDecorator"
    }

    public func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Output where Wrapped.Container == Container {
        Output(rootViewController: screen.build(navigator: navigator))
    }
}

extension Screen where Container: UIViewController {

    /// Wraps the screen container in a navigation controller with the specified class type.
    /// - Parameter type: `UINavigationController` class type.
    /// - Returns: New `Screen` with new container of class type `UINavigationController`.
    @MainActor
    public func withStackContainer<Output: UINavigationController>(
        of type: Output.Type
    ) -> AnyScreen<Output> {
        decorated(by: ScreenStackContainerDecorator<Container, Output>())
    }

    /// Wraps the screen container in a navigation controller.
    /// - Returns: New `Screen` with new container of class `UINavigationController`.
    @MainActor
    public func withStackContainer() -> AnyStackScreen {
        withStackContainer(of: UINavigationController.self)
    }
}
#endif
