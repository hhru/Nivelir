#if canImport(UIKit)
import UIKit

/// Modal screen presentation style.
/// Changes the presentation animation when the screen is shown modally.
public enum ScreenModalStyle {

    /// Default animation using `UIModalPresentationStyle` and `UIModalTransitionStyle`.
    case `default`(
        presentation: UIModalPresentationStyle? = nil,
        transition: UIModalTransitionStyle? = nil
    )

    /// Custom animation using `UIViewControllerTransitioningDelegate` implementation.
    case custom(delegate: UIViewControllerTransitioningDelegate)
}
#endif
