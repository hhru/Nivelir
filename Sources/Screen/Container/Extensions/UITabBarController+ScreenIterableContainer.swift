#if canImport(UIKit)
import UIKit

extension UITabBarController: ScreenIterableContainer {

    /// Returns nested containers in tabs, with the `selectedViewController` container being the last.
    ///
    /// - SeeAlso: `viewControllers`
    /// - SeeAlso: `selectedViewController`
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
