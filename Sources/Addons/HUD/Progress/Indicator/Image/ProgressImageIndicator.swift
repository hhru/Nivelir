#if canImport(UIKit)
import UIKit

/// A progress indicator displaying the image.
///
/// Use this object to configure how the image is displayed in the view.
public struct ProgressImageIndicator: ProgressIndicator {

    public typealias View = ProgressImageIndicatorView

    /// The default configuration.
    /// - Parameter image: The image displayed in the image view.
    public static func `default`(image: UIImage) -> Self {
        Self(image: image)
    }

    /// The image displayed in the image view.
    public let image: UIImage

    /// Additional indents to expand the container.
    public let insets: UIEdgeInsets

    public var logDescription: String? {
        ".image"
    }

    /// Creates new indicator content.
    /// - Parameters:
    ///   - image: The image displayed in the image view.
    ///   - insets: Additional indents to expand the container.
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
