#if canImport(UIKit)
import UIKit

/// A representation of an alert.
public struct Alert: CustomStringConvertible {

    /// The title of the alert.
    public let title: String?

    /// Descriptive text that provides more details about the reason for the alert.
    public let message: String?

    /// Tint color for view of alert.
    public let tintColor: UIColor?

    /// A string that identifies the alert.
    public let accessibilityIdentifier: String?

    /// The text fields to show in the alert.
    public let textFields: [AlertTextField]

    /// The actions to show in the alert.
    public let actions: [AlertAction]

    public var description: String {
        if let description = title ?? message {
            return "Alert(\"\(description)\")"
        } else {
            return "Alert"
        }
    }

    /// Creates an alert representation.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: Descriptive text that provides more details about the reason for the alert.
    ///   - tintColor: Tint color for view of alert.
    ///   - accessibilityIdentifier: The text fields that will be added to the alert.
    ///   - textFields: The text fields to show in the alert.
    ///   - actions: The actions to show in the alert.
    public init(
        title: String?,
        message: String? = nil,
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

    /// Creates an alert representation.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: Descriptive text that provides more details about the reason for the alert.
    ///   - tintColor: Tint color for view of alert.
    ///   - accessibilityIdentifier: The text fields that will be added to the alert.
    ///   - textFields: The text fields to show in the alert.
    ///   - actions: The actions to show in the alert.
    public init(
        title: String? ,
        message: String? = nil,
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

    /// Creates an alert representation with singe text field.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: Descriptive text that provides more details about the reason for the alert.
    ///   - tintColor: Tint color for view of alert.
    ///   - accessibilityIdentifier: The text fields that will be added to the alert.
    ///   - textField: The text field to show in the alert.
    ///   - actions: The actions to show in the alert.
    public init(
        title: String?,
        message: String? = nil,
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
