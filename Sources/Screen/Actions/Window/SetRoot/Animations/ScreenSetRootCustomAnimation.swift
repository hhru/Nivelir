import UIKit

public protocol ScreenSetRootCustomAnimation {

    func animate(
        container: UIWindow,
        from rootContainer: UIViewController?,
        to newRootContainer: UIViewController,
        completion: @escaping () -> Void
    )
}
