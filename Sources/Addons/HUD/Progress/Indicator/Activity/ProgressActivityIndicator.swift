#if canImport(UIKit)
import UIKit

/// A progress indicator that displays an activity indicator.
///
/// Use this object to customize the display of the activity indicator in the view.
public struct ProgressActivityIndicator: ProgressIndicator {

    public typealias View = ProgressActivityIndicatorView

    /// The default configuration.
    public static let `default` = Self()

    /// The color of the activity indicator.
    public let color: UIColor

    /// Outset (or expanded) by the specified amount.
    public let insets: UIEdgeInsets

    public var logDescription: String? {
        ".activity"
    }

    /// Creates new indicator content.
    /// - Parameters:
    ///   - color: The color of the activity indicator.
    ///   - insets: Outset (or expanded) by the specified amount.
    public init(
        color: UIColor = .lightGray,
        insets: UIEdgeInsets = UIEdgeInsets(
            top: 25.5,
            left: 25.5,
            bottom: 25.5,
            right: 25.5
        )
    ) {
        self.color = color
        self.insets = insets
    }
}
#endif
