#if canImport(UIKit)
import UIKit

public struct ProgressActivityIndicator: ProgressIndicator {

    public typealias View = ProgressActivityIndicatorView

    public static let `default` = Self()

    public let color: UIColor
    public let insets: UIEdgeInsets

    public var logDescription: String? {
        "Activity"
    }

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
