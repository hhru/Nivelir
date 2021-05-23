#if canImport(UIKit)
import UIKit

public enum AlertType {

    case alert
    case actionSheet(popoverStyle: AlertPopoverStyle)

    internal var containerStyle: UIAlertController.Style {
        switch self {
        case .alert:
            return .alert

        case .actionSheet:
            return .actionSheet
        }
    }
}
#endif
