#if canImport(UIKit)
import UIKit

public struct ScreenLeftBarButtonDecorator<Container: UIViewController>: ScreenDecorator {

    public let item: UIBarButtonItem

    public var payload: Any? {
        nil
    }

    public init(item: UIBarButtonItem) {
        self.item = item
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

        container.navigationItem.leftBarButtonItem = item

        return container
    }
}

extension Screen where Container: UIViewController {

    public func withLeftBarButton(_ item: UIBarButtonItem) -> AnyScreen<Container> {
        decorated(by: ScreenLeftBarButtonDecorator(item: item))
    }
}
#endif
