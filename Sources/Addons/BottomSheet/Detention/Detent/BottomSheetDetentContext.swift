#if canImport(UIKit)
import UIKit

@MainActor
public protocol BottomSheetDetentContext {

    var presentedViewController: UIViewController { get }
    var containerTraitCollection: UITraitCollection { get }
    var maximumDetentValue: CGFloat { get }
}
#endif
