#if canImport(UIKit)
import UIKit

public struct ScreenStackTransitionAnimation: ScreenStackCustomAnimation, Equatable, Sendable {

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
        container: UINavigationController,
        stack: [UIViewController],
        completion: @escaping () -> Void
    ) {
        UIView.transition(
            with: container.view,
            duration: duration,
            options: options,
            animations: { },
            completion: { _ in
                completion()
            }
        )
    }
}

extension ScreenStackTransitionAnimation {

    public static let crossDissolve = Self(
        duration: 0.3,
        options: .transitionCrossDissolve
    )
}

extension ScreenStackAnimation {

    public static let crossDissolve = Self.custom(
        ScreenStackTransitionAnimation.crossDissolve
    )
}
#endif
