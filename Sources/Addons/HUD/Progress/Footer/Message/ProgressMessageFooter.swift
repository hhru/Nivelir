#if canImport(UIKit)
import UIKit

public struct ProgressMessageFooter: ProgressFooter {

    public typealias View = ProgressMessageFooterView

    public static func `default`(text: String) -> Self {
        Self(text: text)
    }

    public let text: String
    public let font: UIFont
    public let color: UIColor
    public let alignment: NSTextAlignment
    public let insets: UIEdgeInsets

    public var logDescription: String? {
        "Message(\"\(text)\")"
    }

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
