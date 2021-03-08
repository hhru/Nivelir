#if canImport(UIKit)
import UIKit

public protocol ScreenSelectTabCustomAnimation {
    func animate(
        container: UITabBarController,
        from selectedTab: UIViewController,
        to newSelectedTab: UIViewController,
        completion: @escaping () -> Void
    )
}
#endif
