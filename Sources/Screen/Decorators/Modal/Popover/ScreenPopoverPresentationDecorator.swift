#if canImport(UIKit)
import UIKit

public struct ScreenPopoverPresentationDecorator<Container: UIViewController>: ScreenDecorator {

    public let anchor: ScreenPopoverPresentationAnchor

    public var payload: Any? {
        nil
    }

    public var description: String {
        "PopoverPresentationDecorator"
    }

    public init(anchor: ScreenPopoverPresentationAnchor) {
        self.anchor = anchor
    }

    public func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Container where Wrapped.Container == Container {
        let container = screen.build(navigator: navigator)

        guard let popoverPresentationController = container.popoverPresentationController else {
            return container
        }

        if let permittedArrowDirections = anchor.permittedArrowDirections {
            popoverPresentationController.permittedArrowDirections = permittedArrowDirections
        }

        popoverPresentationController.sourceRect = anchor.rect ?? CGRect(
            x: container.view.bounds.midX,
            y: container.view.bounds.midY,
            width: .zero,
            height: .zero
        )

        popoverPresentationController.sourceView = anchor.view ?? container.view
        popoverPresentationController.barButtonItem = anchor.barButtonItem

        return container
    }
}

extension Screen where Container: UIViewController {

    public func withPopoverPresentation(anchor: ScreenPopoverPresentationAnchor) -> AnyScreen<Container> {
        decorated(by: ScreenPopoverPresentationDecorator(anchor: anchor))
    }
}
#endif
