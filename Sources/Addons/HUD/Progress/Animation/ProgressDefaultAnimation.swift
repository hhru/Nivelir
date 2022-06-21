#if canImport(UIKit)
import UIKit

public struct ProgressDefaultAnimation: ProgressCustomAnimation {

    public func animateView(
        _ view: UIView,
        previousView: UIView,
        containerView: UIView
    ) {
        previousView.removeFromSuperview()
        containerView.insertSubview(previousView, at: .zero)

        let constraints = [
            previousView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            previousView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            previousView.widthAnchor.constraint(equalToConstant: previousView.bounds.width),
            previousView.heightAnchor.constraint(equalToConstant: previousView.bounds.height)
        ]

        NSLayoutConstraint.activate(constraints)
        containerView.layoutIfNeeded()

        view.alpha = .zero

        UIView.animate(
            withDuration: 0.25,
            animations: {
                view.alpha = 1.0
                previousView.alpha = .zero
            },
            completion: { _ in
                previousView.removeFromSuperview()
            }
        )
    }
}

extension ProgressAnimation {

    public static let `default` = Self.custom(
        ProgressDefaultAnimation()
    )
}
#endif
