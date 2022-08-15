#if canImport(UIKit)
import UIKit

/// Progress indicator showing the spinner.
///
/// Use this object to customize the display of the spinner in the view.
public struct ProgressSpinnerIndicator: ProgressIndicator {

    public typealias View = ProgressSpinnerIndicatorView

    /// The default configuration.
    public static let `default` = Self()

    /// The color used to stroke the shape’s path.
    public let color: UIColor

    /// Additional indents to expand the container.
    public let insets: UIEdgeInsets

    public var logDescription: String? {
        ".spinner"
    }

    /// Creates new indicator content.
    /// - Parameters:
    ///   - color: The color used to stroke the shape’s path.
    ///   - insets: Additional indents to expand the container.
    public init(
        color: UIColor = .lightGray,
        insets: UIEdgeInsets = UIEdgeInsets(
            top: 20.0,
            left: 20.0,
            bottom: 20.0,
            right: 20.0
        )
    ) {
        self.color = color
        self.insets = insets
    }
}
#endif
