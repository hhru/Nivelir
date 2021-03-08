#if canImport(UIKit)
import UIKit

public enum ScreenModalStyle {

    case `default`(
        presentation: UIModalPresentationStyle? = nil,
        transition: UIModalTransitionStyle? = nil
    )

    case custom(delegate: UIViewControllerTransitioningDelegate)
}
#endif
