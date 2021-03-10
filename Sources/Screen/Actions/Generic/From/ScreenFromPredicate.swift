#if canImport(UIKit)
import UIKit
#else
import Foundation
#endif

public struct ScreenFromPredicate<Container: ScreenContainer> {

    private let box: (_ container: Container) -> Bool

    public init(_ box: @escaping (_ container: Container) -> Bool) {
        self.box = box
    }

    internal func checkContainer(_ container: Container) -> Bool {
        box(container)
    }
}

extension ScreenFromPredicate {

    public static func container(of type: Container.Type) -> Self {
        Self { _ in true }
    }

    public static func container(of type: Container.Type, key: ScreenKey) -> Self {
        Self { container in
            guard let container = container as? ScreenKeyProvider else {
                return false
            }

            return container.screenKey == key
        }
    }
}

#if canImport(UIKit)
extension ScreenFromPredicate where Container == UIViewController {

    public static var modalContainer: Self {
        container(of: Container.self)
    }

    public static func modalContainer(key: ScreenKey) -> Self {
        container(of: Container.self, key: key)
    }
}

extension ScreenFromPredicate where Container == UINavigationController {

    public static var stackContainer: Self {
        container(of: Container.self)
    }

    public static func stackContainer(key: ScreenKey) -> Self {
        container(of: Container.self, key: key)
    }
}

extension ScreenFromPredicate where Container == UITabBarController {

    public static var tabsContainer: Self {
        container(of: Container.self)
    }

    public static func tabsContainer(key: ScreenKey) -> Self {
        container(of: Container.self, key: key)
    }
}
#endif
