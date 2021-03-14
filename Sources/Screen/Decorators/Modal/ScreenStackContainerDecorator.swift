#if canImport(UIKit)
import UIKit

public struct ScreenStackContainerDecorator<
    Container: UIViewController,
    Output: UINavigationController
>: ScreenDecorator {

    public var payload: Any? {
        nil
    }

    public var description: String {
        "StackContainerDecorator"
    }

    public init() { }

    public func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Output where Wrapped.Container == Container {
        Output(rootViewController: screen.build(navigator: navigator))
    }
}

extension Screen where Container: UIViewController {

    public func withStackContainer<Output: UINavigationController>(
        of type: Output.Type
    ) -> AnyScreen<Output> {
        decorated(by: ScreenStackContainerDecorator<Container, Output>())
    }

    public func withStackContainer() -> AnyStackScreen {
        withStackContainer(of: UINavigationController.self)
    }
}
#endif
