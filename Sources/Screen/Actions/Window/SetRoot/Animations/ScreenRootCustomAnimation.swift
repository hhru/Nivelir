#if canImport(UIKit)
import UIKit

public protocol ScreenRootCustomAnimation {

    func animate(
        container: UIWindow,
        from root: UIViewController?,
        to newRoot: UIViewController,
        completion: @escaping () -> Void
    )
}
#endif
