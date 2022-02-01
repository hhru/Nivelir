#if canImport(UIKit)
import UIKit

extension UITabBarController: ScreenIterableContainer {

    public var nestedContainers: [ScreenContainer] {
        let tabContainers = viewControllers ?? []

        return selectedViewController.map { selectedContainer in
            tabContainers
                .removingAll { $0 === selectedContainer }
                .appending(selectedContainer)
        } ?? tabContainers
    }
}
#endif
