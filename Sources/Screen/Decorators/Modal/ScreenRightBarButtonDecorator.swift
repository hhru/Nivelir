#if canImport(UIKit)
import UIKit

/// Sets the `rightBarButtonItem` for the `navigationItem` of container of type `UIViewController`.
public struct ScreenRightBarButtonDecorator<Container: UIViewController>: ScreenDecorator {

    public let item: UIBarButtonItem

    public var payload: Any? {
        nil
    }

    public var description: String {
        "RightBarButtonDecorator"
    }

    public init(item: UIBarButtonItem) {
        self.item = item
    }

    public func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Container where Wrapped.Container == Container {
        let container = screen.build(navigator: navigator)

        container.navigationItem.rightBarButtonItem = item

        return container
    }
}

extension Screen where Container: UIViewController {

    /// Sets the `rightBarButtonItem` for the `navigationItem`
    /// - Parameter item: `item` to set.
    /// - Returns: New `Screen` with `UIBarButtonItem` set to `rightBarButtonItem`.
    ///
    /// - SeeAlso: `UINavigationItem`
    /// - SeeAlso: `UIBarButtonItem`
    public func withRightBarButton(_ item: UIBarButtonItem) -> AnyScreen<Container> {
        decorated(by: ScreenRightBarButtonDecorator(item: item))
    }
}
#endif
