#if canImport(UIKit)
import UIKit

public struct ScreenRightBarButtonDecorator<Container: UIViewController>: ScreenDecorator {

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

        container.navigationItem.rightBarButtonItem = item

        return container
    }
}

extension Screen where Container: UIViewController {

    public func withRightBarButton(_ item: UIBarButtonItem) -> AnyScreen<Container> {
        decorated(by: ScreenRightBarButtonDecorator(item: item))
    }
}
#endif
