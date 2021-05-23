#if canImport(UIKit)
import UIKit

public struct Alert: CustomStringConvertible {

    public let title: String?
    public let message: String?
    public let tintColor: UIColor?
    public let accessibilityIdentifier: String?
    public let textFields: [AlertTextField]
    public let actions: [AlertAction]

    public var description: String {
        "Alert(\"\(title ?? message ?? "")\")"
    }

    public init(
        title: String?,
        message: String?,
        tintColor: UIColor? = nil,
        accessibilityIdentifier: String? = nil,
        textFields: [AlertTextField] = [],
        actions: [AlertAction] = []
    ) {
        self.title = title
        self.message = message
        self.tintColor = tintColor
        self.accessibilityIdentifier = accessibilityIdentifier
        self.textFields = textFields
        self.actions = actions
    }

    public init(
        title: String?,
        message: String?,
        tintColor: UIColor? = nil,
        accessibilityIdentifier: String? = nil,
        textFields: [AlertTextField] = [],
        actions: AlertAction...
    ) {
        self.init(
            title: title,
            message: message,
            tintColor: tintColor,
            accessibilityIdentifier: accessibilityIdentifier,
            textFields: textFields,
            actions: actions
        )
    }

    public init(
        title: String?,
        message: String?,
        tintColor: UIColor? = nil,
        accessibilityIdentifier: String? = nil,
        textField: AlertTextField,
        actions: AlertAction...
    ) {
        self.init(
            title: title,
            message: message,
            tintColor: tintColor,
            accessibilityIdentifier: accessibilityIdentifier,
            textFields: [textField],
            actions: actions
        )
    }
}
#endif
