#if canImport(UIKit)
import UIKit

public struct AlertPopoverStyle {

    public let source: AlertPopoverSource
    public let permittedArrowDirections: UIPopoverArrowDirection?

    public init(
        source: AlertPopoverSource,
        permittedArrowDirections: UIPopoverArrowDirection? = nil
    ) {
        self.source = source
        self.permittedArrowDirections = permittedArrowDirections
    }
}

extension AlertPopoverStyle {

    public static func fromCenter(permittedArrowDirections: UIPopoverArrowDirection? = nil) -> Self {
        Self(
            source: .center,
            permittedArrowDirections: permittedArrowDirections
        )
    }

    public static func fromBarButtonItem(
        _ barButtonItem: UIBarButtonItem,
        permittedArrowDirections: UIPopoverArrowDirection? = nil
    ) -> Self {
        Self(
            source: .barButtonItem(barButtonItem),
            permittedArrowDirections: permittedArrowDirections
        )
    }

    public static func fromRect(
        _ rect: CGRect,
        view: UIView?,
        permittedArrowDirections: UIPopoverArrowDirection? = nil
    ) -> Self {
        Self(
            source: .rect(rect, view: view),
            permittedArrowDirections: permittedArrowDirections
        )
    }
}
#endif
