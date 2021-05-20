#if canImport(UIKit)
import UIKit

public struct ScreenRootTransitionAnimation: ScreenRootCustomAnimation {

    public let duration: TimeInterval
    public let options: UIView.AnimationOptions

    public init(
        duration: TimeInterval,
        options: UIView.AnimationOptions
    ) {
        self.duration = duration
        self.options = options
    }

    public func animate(
        container: UIWindow,
        from root: UIViewController?,
        to newRoot: UIViewController,
        completion: @escaping () -> Void
    ) {
        UIView.transition(
            with: container,
            duration: duration,
            options: options,
            animations: { },
            completion: { _ in
                completion()
            }
        )
    }
}

extension ScreenRootTransitionAnimation {

    public static let crossDissolve = Self(
        duration: 0.3,
        options: .transitionCrossDissolve
    )
}

extension ScreenRootAnimation {

    public static let crossDissolve = Self.custom(
        ScreenRootTransitionAnimation.crossDissolve
    )
}
#endif
