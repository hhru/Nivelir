#if canImport(UIKit)
import UIKit

public enum ScreenTabAnimation {

    case custom(ScreenTabCustomAnimation)

    public func animate(
        container: UITabBarController,
        from selectedTab: UIViewController,
        to newSelectedTab: UIViewController,
        completion: @escaping () -> Void
    ) {
        switch self {
        case let .custom(animation):
            animation.animate(
                container: container,
                from: selectedTab,
                to: newSelectedTab,
                completion: completion
            )
        }
    }
}
#endif
