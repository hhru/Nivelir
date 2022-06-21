#if canImport(UIKit)
import UIKit

public struct ProgressSuccessIndicator: ProgressIndicator {

    public typealias View = ProgressSuccessIndicatorView

    public static let `default` = Self()

    public let color: UIColor
    public let insets: UIEdgeInsets

    public var logDescription: String? {
        "Success"
    }

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
