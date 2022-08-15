#if canImport(UIKit)
import UIKit

/// Progress indicator displaying an error with an animated cross.
///
/// Use this object to customize the display of the cross in the view.
public struct ProgressFailureIndicator: ProgressIndicator {

    public typealias View = ProgressFailureIndicatorView

    /// The default configuration.
    public static let `default` = Self()

    /// The color used to stroke the shape’s path.
    public let color: UIColor

    /// Insets relative to the superview.
    public let insets: UIEdgeInsets

    public var logDescription: String? {
        ".failure"
    }

    /// Creates new indicator content.
    /// - Parameters:
    ///   - color: The color used to stroke the shape’s path.
    ///   - insets: Insets relative to the superview.
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
