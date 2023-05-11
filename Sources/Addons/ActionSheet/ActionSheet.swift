#if canImport(UIKit)
import UIKit

/// A representation of an action sheet.
public struct ActionSheet: CustomStringConvertible {

    /// The title of the action sheet.
    public let title: String?

    /// The message to display in the body of the action sheet.
    public let message: String?

    /// Anchor for a popover.
    public let anchor: ScreenPopoverPresentationAnchor

    /// Tint color for view of action sheet.
    public let tintColor: UIColor?

    /// A string that identifies the action sheet.
    public let accessibilityIdentifier: String?

    /// The actions to show in the action sheet.
    public let actions: [ActionSheetAction]

    public var description: String {
        if let description = title ?? message {
            return "ActionSheet(\"\(description)\")"
        }

        return "ActionSheet"
    }

    /// Creates an action sheet representation.
    /// - Parameters:
    ///   - title: The title of the action sheet.
    ///   - message: The message to display in the body of the action sheet.
    ///   - anchor: Anchor for a popover.
    ///   - tintColor: Tint color for view of action sheet.
    ///   - accessibilityIdentifier: A string that identifies the action sheet.
    ///   - actions: The actions to show in the action sheet.
    public init(
        title: String? = nil,
        message: String? = nil,
        anchor: ScreenPopoverPresentationAnchor,
        tintColor: UIColor? = nil,
        accessibilityIdentifier: String? = nil,
        actions: [ActionSheetAction] = []
    ) {
        self.title = title
        self.message = message
        self.anchor = anchor
        self.tintColor = tintColor
        self.accessibilityIdentifier = accessibilityIdentifier
        self.actions = actions
    }

    /// Creates an action sheet configuration.
    /// - Parameters:
    ///   - title: The title of the action sheet.
    ///   - message: The message to display in the body of the action sheet.
    ///   - anchor: Anchor for a popover.
    ///   - tintColor: Tint color for view of action sheet.
    ///   - accessibilityIdentifier: A string that identifies the action sheet.
    ///   - actions: The actions to show in the action sheet.
    public init(
        title: String? = nil,
        message: String? = nil,
        anchor: ScreenPopoverPresentationAnchor,
        tintColor: UIColor? = nil,
        accessibilityIdentifier: String? = nil,
        actions: ActionSheetAction...
    ) {
        self.init(
            title: title,
            message: message,
            anchor: anchor,
            tintColor: tintColor,
            accessibilityIdentifier: accessibilityIdentifier,
            actions: actions
        )
    }
}
#endif
