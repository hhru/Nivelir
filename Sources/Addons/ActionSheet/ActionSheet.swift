#if canImport(UIKit)
import UIKit

public struct ActionSheet: CustomStringConvertible {

    public let title: String?
    public let message: String?
    public let source: ActionSheetSource
    public let tintColor: UIColor?
    public let accessibilityIdentifier: String?
    public let actions: [ActionSheetAction]

    public var description: String {
        if let description = title ?? message {
            return "ActionSheet(\"\(description)\")"
        } else {
            return "ActionSheet"
        }
    }

    public init(
        title: String? = nil,
        message: String? = nil,
        source: ActionSheetSource,
        tintColor: UIColor? = nil,
        accessibilityIdentifier: String? = nil,
        actions: [ActionSheetAction] = []
    ) {
        self.title = title
        self.message = message
        self.source = source
        self.tintColor = tintColor
        self.accessibilityIdentifier = accessibilityIdentifier
        self.actions = actions
    }

    public init(
        title: String? = nil,
        message: String? = nil,
        source: ActionSheetSource,
        tintColor: UIColor? = nil,
        accessibilityIdentifier: String? = nil,
        actions: ActionSheetAction...
    ) {
        self.init(
            title: title,
            message: message,
            source: source,
            tintColor: tintColor,
            accessibilityIdentifier: accessibilityIdentifier,
            actions: actions
        )
    }
}
#endif
