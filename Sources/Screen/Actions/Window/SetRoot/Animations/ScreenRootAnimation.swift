#if canImport(UIKit)
import UIKit

@MainActor
@frozen
public enum ScreenRootAnimation {

    case custom(ScreenRootCustomAnimation)

    public func animate(
        container: UIWindow,
        from root: UIViewController?,
        to newRoot: UIViewController,
        completion: @escaping () -> Void
    ) {
        switch self {
        case let .custom(animation):
            animation.animate(
                container: container,
                from: root,
                to: newRoot,
                completion: completion
            )
        }
    }
}
#endif
