#if canImport(UIKit)
import UIKit

@MainActor
public protocol ScreenRootCustomAnimation {

    func animate(
        container: UIWindow,
        from root: UIViewController?,
        to newRoot: UIViewController,
        completion: @escaping () -> Void
    )
}
#endif
