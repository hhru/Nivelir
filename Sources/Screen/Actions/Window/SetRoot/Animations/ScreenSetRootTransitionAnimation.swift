import UIKit

public struct ScreenSetRootTransitionAnimation: ScreenSetRootCustomAnimation {

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
        from rootContainer: UIViewController?,
        to newRootContainer: UIViewController,
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

extension ScreenSetRootTransitionAnimation {

    public static let crossDissolve = Self(
        duration: 0.3,
        options: .transitionCrossDissolve
    )
}

extension ScreenSetRootAnimation {

    public static let crossDissolve = Self.custom(
        ScreenSetRootTransitionAnimation.crossDissolve
    )
}
