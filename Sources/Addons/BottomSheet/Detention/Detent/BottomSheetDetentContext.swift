#if canImport(UIKit)
import UIKit

public protocol BottomSheetDetentContext {

    var presentedViewController: UIViewController { get }
    var containerTraitCollection: UITraitCollection { get }
    var maximumDetentValue: CGFloat { get }
}
#endif
