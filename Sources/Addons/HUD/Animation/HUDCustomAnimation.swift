#if canImport(UIKit)
import UIKit

public protocol HUDCustomAnimation {

    func animateAppearance(
        of view: UIView,
        completion: (() -> Void)?
    )

    func animateUpdate(
        body: @escaping () -> Void,
        of view: UIView,
        completion: (() -> Void)?
    )

    func animateDisappearance(
        of view: UIView,
        completion: (() -> Void)?
    )
}
#endif
