#if canImport(UIKit)
import UIKit

public struct ActionSheet: CustomStringConvertible {

    public let title: String?
    public let message: String?
    public let popoverStyle: ActionSheetPopoverStyle
    public let tintColor: UIColor?
    public let accessibilityIdentifier: String?
    public let actions: [ActionSheetAction]

    public var description: String {
        "ActionSheet(\"\(title ?? message ?? "")\")"
    }

    public init(
        title: String?,
        message: String?,
        popoverStyle: ActionSheetPopoverStyle,
        tintColor: UIColor? = nil,
        accessibilityIdentifier: String? = nil,
        actions: [ActionSheetAction] = []
    ) {
        self.title = title
        self.message = message
        self.popoverStyle = popoverStyle
        self.tintColor = tintColor
        self.accessibilityIdentifier = accessibilityIdentifier
        self.actions = actions
    }

    public init(
        title: String?,
        message: String?,
        popoverStyle: ActionSheetPopoverStyle,
        tintColor: UIColor? = nil,
        accessibilityIdentifier: String? = nil,
        actions: ActionSheetAction...
    ) {
        self.init(
            title: title,
            message: message,
            popoverStyle: popoverStyle,
            tintColor: tintColor,
            accessibilityIdentifier: accessibilityIdentifier,
            actions: actions
        )
    }
}
#endif
