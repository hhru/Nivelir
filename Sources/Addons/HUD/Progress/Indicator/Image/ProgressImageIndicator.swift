#if canImport(UIKit)
import UIKit

public struct ProgressImageIndicator: ProgressIndicator {

    public typealias View = ProgressImageIndicatorView

    public static func `default`(image: UIImage) -> Self {
        Self(image: image)
    }

    public let image: UIImage
    public let insets: UIEdgeInsets

    public var logDescription: String? {
        ".image"
    }

    public init(
        image: UIImage,
        insets: UIEdgeInsets = UIEdgeInsets(
            top: 20.0,
            left: 20.0,
            bottom: 20.0,
            right: 20.0
        )
    ) {
        self.image = image
        self.insets = insets
    }
}
#endif
