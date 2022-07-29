#if canImport(UIKit)
import UIKit

/// Sets the `leftBarButtonItem` for the `navigationItem` of container of type `UIViewController`.
public struct ScreenLeftBarButtonDecorator<Container: UIViewController>: ScreenDecorator {

    public let item: UIBarButtonItem

    public var payload: Any? {
        nil
    }

    public var description: String {
        "LeftBarButtonDecorator"
    }

    public init(item: UIBarButtonItem) {
        self.item = item
    }

    public func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Container where Wrapped.Container == Container {
        let container = screen.build(navigator: navigator)

        container.navigationItem.leftBarButtonItem = item

        return container
    }
}

extension Screen where Container: UIViewController {

    /// Sets the `leftBarButtonItem` for the `navigationItem`
    /// - Parameter item: `item` to set.
    /// - Returns: New `Screen` with `UIBarButtonItem` set to `leftBarButtonItem`.
    ///
    /// - SeeAlso: `UINavigationItem`
    /// - SeeAlso: `UIBarButtonItem`
    public func withLeftBarButton(_ item: UIBarButtonItem) -> AnyScreen<Container> {
        decorated(by: ScreenLeftBarButtonDecorator(item: item))
    }
}
#endif
