#if canImport(UIKit)
import UIKit

/// Progress indicator displaying percentages with an animated circle fill.
///
/// Use this object to customize the display of progress in the view.
public struct ProgressPercentageIndicator: ProgressIndicator {

    public typealias View = ProgressPercentageIndicatorView

    /// The default configuration.
    /// - Parameter ratio: A measure of progress through the task, given as a fraction in the range [0, 1].
    public static func `default`(ratio: CGFloat) -> Self {
        Self(ratio: ratio)
    }

    /// A measure of progress through the task, given as a fraction in the range [0, 1].
    public let ratio: CGFloat

    /// The color used to stroke the shape’s path and text.
    public let color: UIColor

    /// Additional indents to expand the container.
    public let insets: UIEdgeInsets

    public let logDescription: String?

    /// Creates new indicator content.
    /// - Parameters:
    ///   - ratio: A measure of progress through the task, given as a fraction in the range [0, 1].
    ///   - color: The color used to stroke the shape’s path and text.
    ///   - insets: Additional indents to expand the container.
    public init(
        ratio: CGFloat,
        color: UIColor = .lightGray,
        insets: UIEdgeInsets = UIEdgeInsets(
            top: 20.0,
            left: 20.0,
            bottom: 20.0,
            right: 20.0
        )
    ) {
        self.ratio = ratio
        self.color = color
        self.insets = insets
        logDescription = ".percentage(\(ratio))"
    }

    @MainActor
    public func updateContentView(_ contentView: View) -> View {
        contentView.content = self

        return contentView
    }
}
#endif
