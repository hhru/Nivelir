#if canImport(UIKit)
import UIKit

public enum AlertPopoverSource {

    case center
    case barButtonItem(UIBarButtonItem)
    case rect(CGRect, view: UIView? = nil)
}
#endif
