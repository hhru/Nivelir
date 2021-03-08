import UIKit

public enum ScreenSetRootAnimation {

    case custom(ScreenSetRootCustomAnimation)

    public func animate(
        container: UIWindow,
        from rootContainer: UIViewController?,
        to newRootContainer: UIViewController,
        completion: @escaping () -> Void
    ) {
        switch self {
        case let .custom(animation):
            animation.animate(
                container: container,
                from: rootContainer,
                to: newRootContainer,
                completion: completion
            )
        }
    }
}
