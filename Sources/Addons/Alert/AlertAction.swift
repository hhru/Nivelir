#if canImport(UIKit)
import UIKit

/// A action representing an operation of an alert presentation.
public struct AlertAction {

    public typealias Enabler = (_ texts: [String]) -> Bool
    public typealias Handler = (_ texts: [String]) -> Void

    /// The text to display on the action.
    public let title: String

    /// The style applied to the action button in the alert.
    public let style: UIAlertAction.Style

    /// A closure indicating whether the action is currently enabled depending on the text in the added text fields.
    ///
    /// Closure takes an array of strings as an argument from the text fields added to the alert
    /// and returns a Boolean value.
    public let enabler: Enabler?

    /// A closure to execute when the user taps or presses the action.
    ///
    /// The closure takes an array of strings as an argument from the text fields added to the alert.
    public let handler: Handler?

    /// Creates an alert button configuration.
    /// - Parameters:
    ///   - title: The text to display on the action.
    ///   - style: The style applied to the action button in the alert.
    ///   - enabler: A closure indicating whether the action is currently enabled
    ///   depending on the text in the added text fields.
    ///   - handler: A closure to execute when the user taps or presses the action.
    public init(
        title: String,
        style: UIAlertAction.Style = .default,
        enabler: Enabler? = nil,
        handler: Handler? = nil
    ) {
        self.title = title
        self.style = style
        self.enabler = enabler
        self.handler = handler
    }

    public init(
        title: String,
        style: UIAlertAction.Style = .default,
        enabler: Enabler? = nil,
        handler: (() -> Void)?
    ) {
        self.init(title: title, style: style, enabler: enabler) { _ in
            handler?()
        }
    }
}

extension AlertAction {

    public static func cancel(title: String) -> Self {
        Self(title: title, style: .cancel)
    }
}
#endif
