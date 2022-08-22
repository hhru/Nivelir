#if canImport(UIKit)
import UIKit

/// A progress indicator displaying an animated checkmark.
///
/// Use this object to customize the display of the checkmark in the view.
public struct ProgressSuccessIndicator: ProgressIndicator {

    public typealias View = ProgressSuccessIndicatorView

    /// The default configuration.
    public static let `default` = Self()

    /// The color used to stroke the shape’s path.
    public let color: UIColor

    /// Additional indents to expand the container.
    public let insets: UIEdgeInsets

    public var logDescription: String? {
        ".success"
    }

    /// Creates new indicator content.
    /// - Parameters:
    ///   - color: The color used to stroke the shape’s path.
    ///   - insets: Additional indents to expand the container.
    public init(
        color: UIColor = .lightGray,
        insets: UIEdgeInsets = UIEdgeInsets(
            top: 24.0,
            left: 24.0,
            bottom: 24.0,
            right: 24.0
        )
    ) {
        self.color = color
        self.insets = insets
    }
}
#endif
