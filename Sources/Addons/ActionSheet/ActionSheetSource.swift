#if canImport(UIKit)
import UIKit

public struct ActionSheetSource {

    public let rect: CGRect?
    public let view: UIView?
    public let barButtonItem: UIBarButtonItem?
    public let permittedArrowDirections: UIPopoverArrowDirection?

    private init(
        rect: CGRect? = nil,
        view: UIView? = nil,
        barButtonItem: UIBarButtonItem? = nil,
        permittedArrowDirections: UIPopoverArrowDirection?
    ) {
        self.rect = rect
        self.view = view
        self.barButtonItem = barButtonItem
        self.permittedArrowDirections = permittedArrowDirections
    }
}

extension ActionSheetSource {

    public static func center(permittedArrowDirections: UIPopoverArrowDirection? = nil) -> Self {
        Self(permittedArrowDirections: permittedArrowDirections)
    }

    public static func center(
        of view: UIView,
        permittedArrowDirections: UIPopoverArrowDirection? = nil
    ) -> Self {
        Self(
            rect: CGRect(origin: view.center, size: .zero),
            view: view,
            permittedArrowDirections: permittedArrowDirections
        )
    }

    public static func rect(
        _ rect: CGRect,
        of view: UIView? = nil,
        permittedArrowDirections: UIPopoverArrowDirection? = nil
    ) -> Self {
        Self(
            rect: rect,
            view: view,
            permittedArrowDirections: permittedArrowDirections
        )
    }

    public static func barButtonItem(
        _ barButtonItem: UIBarButtonItem,
        permittedArrowDirections: UIPopoverArrowDirection? = nil
    ) -> Self {
        Self(
            barButtonItem: barButtonItem,
            permittedArrowDirections: permittedArrowDirections
        )
    }
}
#endif
