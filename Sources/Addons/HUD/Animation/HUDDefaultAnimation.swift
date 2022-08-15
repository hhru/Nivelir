#if canImport(UIKit)
import UIKit

/// Default show, update and hide animation of ``HUD``.
public struct HUDDefaultAnimation: HUDCustomAnimation {

    public func animateAppearance(
        of view: UIView,
        completion: (() -> Void)?
    ) {
        view.layoutIfNeeded()
        view.alpha = .zero

        UIView.animate(
            withDuration: 0.25,
            animations: {
                view.alpha = 1.0
            },
            completion: { _ in
                completion?()
            }
        )
    }

    public func animateUpdate(
        body: @escaping () -> Void,
        of view: UIView,
        completion: (() -> Void)?
    ) {
        UIView.animate(
            withDuration: 0.25,
            animations: body
        ) { _ in
            completion?()
        }
    }

    public func animateDisappearance(
        of view: UIView,
        completion: (() -> Void)?
    ) {
        UIView.animate(
            withDuration: 0.25,
            animations: {
                view.alpha = .zero
            },
            completion: { _ in
                completion?()
            }
        )
    }
}

extension HUDAnimation {

    /// Default show, update and hide animation of ``HUD``.
    public static let `default` = Self.custom(
        HUDDefaultAnimation()
    )
}
#endif
