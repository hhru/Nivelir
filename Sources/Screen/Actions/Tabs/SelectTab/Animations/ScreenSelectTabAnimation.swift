#if canImport(UIKit)
import UIKit

public enum ScreenSelectTabAnimation {

    case custom(ScreenSelectTabCustomAnimation)

    public func animate(
        container: UITabBarController,
        from selectedContainer: UIViewController,
        to newSelectedContainer: UIViewController,
        completion: @escaping () -> Void
    ) {
        switch self {
        case let .custom(animation):
            animation.animate(
                container: container,
                from: selectedContainer,
                to: newSelectedContainer,
                completion: completion
            )
        }
    }
}
#endif
