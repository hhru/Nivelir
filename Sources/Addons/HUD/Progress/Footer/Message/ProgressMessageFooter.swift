#if canImport(UIKit)
import UIKit

/// Footer of progress, displaying text.
///
/// Use this object to customize the display of text in the view.
public struct ProgressMessageFooter: ProgressFooter {

    public typealias View = ProgressMessageFooterView

    /// The default configuration with text.
    /// - Parameter text: The text that the label displays.
    public static func `default`(text: String) -> Self {
        Self(text: text)
    }

    /// The text that the label displays.
    public let text: String

    /// The font of the text.
    public let font: UIFont

    /// The color of the text.
    public let color: UIColor

    /// The technique for aligning the text.
    public let alignment: NSTextAlignment

    /// Insets relative to the superview.
    public let insets: UIEdgeInsets

    public var logDescription: String? {
        ".message(\"\(text)\")"
    }

    /// Creates new footer content.
    /// - Parameters:
    ///   - text: The text that the label displays.
    ///   - font: The font of the text.
    ///   - color: The color of the text.
    ///   - alignment: The technique for aligning the text.
    ///   - insets: Insets relative to the superview.
    public init(
        text: String,
        font: UIFont = .boldSystemFont(ofSize: 16.0),
        color: UIColor,
        alignment: NSTextAlignment = .center,
        insets: UIEdgeInsets = UIEdgeInsets(
            top: .zero,
            left: 20.0,
            bottom: 12.0,
            right: 20.0
        )
    ) {
        self.text = text
        self.font = font
        self.color = color
        self.alignment = alignment
        self.insets = insets
    }

    /// Creates new footer content.
    /// - Parameters:
    ///   - text: The text that the label displays.
    ///   - font: The font of the text.
    ///   - alignment: The technique for aligning the text.
    ///   - insets: Insets relative to the superview.
    public init(
        text: String = "",
        font: UIFont = .boldSystemFont(ofSize: 16.0),
        alignment: NSTextAlignment = .center,
        insets: UIEdgeInsets = UIEdgeInsets(
            top: .zero,
            left: 20.0,
            bottom: 12.0,
            right: 20.0
        )
    ) {
        self.text = text
        self.font = font

        if #available(iOS 13.0, tvOS 13.0, *) {
            color = .label
        } else {
            color = .black
        }

        self.alignment = alignment
        self.insets = insets
    }
}
#endif
