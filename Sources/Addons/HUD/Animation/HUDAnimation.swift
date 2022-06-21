#if canImport(UIKit)
import UIKit

public enum HUDAnimation {

    case custom(HUDCustomAnimation)

    public func animateAppearance(
        of view: UIView,
        completion: (() -> Void)?
    ) {
        switch self {
        case let .custom(animation):
            animation.animateAppearance(
                of: view,
                completion: completion
            )
        }
    }

    public func animateUpdate(
        body: @escaping () -> Void,
        of view: UIView,
        completion: (() -> Void)?
    ) {
        switch self {
        case let .custom(animation):
            animation.animateUpdate(
                body: body,
                of: view,
                completion: completion
            )
        }
    }

    public func animateDisappearance(
        of view: UIView,
        completion: (() -> Void)?
    ) {
        switch self {
        case let .custom(animation):
            animation.animateDisappearance(
                of: view,
                completion: completion
            )
        }
    }
}
#endif
