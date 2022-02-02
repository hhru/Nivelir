#if canImport(UIKit)
import UIKit

extension UINavigationController: ScreenIterableContainer {

    public var nestedContainers: [ScreenContainer] {
        viewControllers
    }
}
#endif
