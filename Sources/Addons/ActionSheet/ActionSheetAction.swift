#if canImport(UIKit)
import UIKit

/// An action representing the action sheet operation.
public struct ActionSheetAction {

    public typealias Handler = () -> Void

    /// The text to display on the action.
    public let title: String

    /// The style applied to the action button in the action sheet.
    public let style: UIAlertAction.Style

    /// A closure to execute when the user taps or presses the action.
    public let handler: Handler?

    /// Creates an action sheet button configuration.
    /// - Parameters:
    ///   - title: The text to display on the action.
    ///   - style: The style applied to the action button in the action sheet.
    ///   - handler: A closure to execute when the user taps or presses the action.
    public init(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: Handler? = nil
    ) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

extension ActionSheetAction {

    /// Creates an action sheet cancel button with a custom title.
    /// - Parameter title: The text to display on the action.
    /// - Returns: An action sheet cancel button.
    public static func cancel(title: String) -> Self {
        Self(title: title, style: .cancel)
    }
}
#endif
