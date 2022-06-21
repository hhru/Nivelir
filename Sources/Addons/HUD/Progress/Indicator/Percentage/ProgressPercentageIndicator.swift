#if canImport(UIKit)
import UIKit

public struct ProgressPercentageIndicator: ProgressIndicator {

    public typealias View = ProgressPercentageIndicatorView

    public static func `default`(ratio: CGFloat) -> Self {
        Self(ratio: ratio)
    }

    public let ratio: CGFloat
    public let color: UIColor
    public let insets: UIEdgeInsets

    public var logDescription: String? {
        "Percentage(\(ratio))"
    }

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
    }

    public func updateContentView(_ contentView: View) -> View {
        contentView.content = self

        return contentView
    }
}
#endif
