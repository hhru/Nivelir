#if canImport(UIKit)
import UIKit

/// Types of text fields added to the alert.
public enum AlertTextField: Sendable {

    /// A text field, with text and placeholder customization.
    case standard(
        text: String,
        placeholder: String? = nil
    )

    /// A text field, customizable via block for configuring the text field prior to displaying the alert.
    /// This block has no return value and takes a single parameter corresponding to the text field object.
    /// Use that parameter to change the text field properties.
    case custom(configuration: @Sendable (UITextField) -> Void)
}

extension AlertTextField {

    /// A text field, with empty text and a placeholder.
    public static let standard = Self.standard(text: "")
}
#endif
