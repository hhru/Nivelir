#if canImport(UIKit)
import UIKit

public struct ProgressSpinnerIndicator: ProgressIndicator {

    public typealias View = ProgressSpinnerIndicatorView

    public static let `default` = Self()

    public let color: UIColor
    public let insets: UIEdgeInsets

    public var logDescription: String? {
        "Spinner"
    }

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
