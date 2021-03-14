#if canImport(UIKit)
import UIKit

public struct ScreenTabTransitionAnimation: ScreenTabCustomAnimation {

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
        container: UITabBarController,
        from selectedTab: UIViewController,
        to newSelectedTab: UIViewController,
        completion: @escaping () -> Void
    ) {
        UIView.transition(
            from: selectedTab.view,
            to: newSelectedTab.view,
            duration: duration,
            options: options
        ) { _ in
            completion()
        }
    }
}

extension ScreenTabTransitionAnimation {

    public static let crossDissolve = Self(
        duration: 0.3,
        options: .transitionCrossDissolve
    )
}

extension ScreenTabAnimation {

    public static let crossDissolve = Self.custom(
        ScreenTabTransitionAnimation.crossDissolve
    )
}
#endif
