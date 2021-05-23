#if canImport(UIKit)
import UIKit

public struct Alert {

    public let type: AlertType
    public let title: String?
    public let message: String?
    public let tintColor: UIColor?
    public let accessibilityIdentifier: String?
    public let actions: [AlertAction]

    public init(
        type: AlertType = .alert,
        title: String?,
        message: String?,
        tintColor: UIColor? = nil,
        accessibilityIdentifier: String? = nil,
        actions: [AlertAction] = []
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.tintColor = tintColor
        self.accessibilityIdentifier = accessibilityIdentifier
        self.actions = actions
    }

    public init(
        type: AlertType = .alert,
        title: String?,
        message: String?,
        tintColor: UIColor? = nil,
        accessibilityIdentifier: String? = nil,
        actions: AlertAction...
    ) {
        self.init(
            type: type,
            title: title,
            message: message,
            tintColor: tintColor,
            accessibilityIdentifier: accessibilityIdentifier,
            actions: actions
        )
    }
}

extension UIAlertController {

    public convenience init(alert: Alert) {
        self.init(
            title: alert.title,
            message: alert.message,
            preferredStyle: alert.type.containerStyle
        )

        if let tintColor = alert.tintColor {
            view.tintColor = tintColor
        }

        if let accessibilityIdentifier = alert.accessibilityIdentifier {
            view.accessibilityIdentifier = accessibilityIdentifier
        }

        alert
            .actions
            .map { $0.containerAction }
            .forEach { addAction($0) }
    }
}
#endif
