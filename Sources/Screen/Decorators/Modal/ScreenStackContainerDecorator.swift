#if canImport(UIKit)
import UIKit

public struct ScreenStackContainerDecorator<
    Container: UIViewController,
    Output: UINavigationController
>: ScreenDecorator {

    public var payload: Any? {
        nil
    }

    public init() { }

    public func buildDecorated<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator,
        associating payload: Any?
    ) -> Output where Wrapped.Container == Container {
        let container = screen.build(
            navigator: navigator,
            associating: payload
        )

        return Output(rootViewController: container)
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
