#if canImport(UIKit)
import UIKit
#else
import Foundation
#endif

public struct ScreenPredicate<Container: ScreenContainer> {

    private let box: (_ container: Container) -> Bool

    public init(_ box: @escaping (_ container: Container) -> Bool) {
        self.box = box
    }

    internal func checkContainer(_ container: ScreenContainer) -> Bool {
        guard let container = container as? Container else {
            return false
        }

        return box(container)
    }
}

extension ScreenPredicate {

    public static func container(of type: Container.Type) -> Self {
        Self { _ in true }
    }

    public static func container(of type: Container.Type, name: String) -> Self {
        Self { container in
            guard let container = container as? ScreenKeyedContainer else {
                return false
            }

            return container.screenKey.name == name
        }
    }

    public static func container(of type: Container.Type, key: ScreenKey) -> Self {
        Self { container in
            guard let container = container as? ScreenKeyedContainer else {
                return false
            }

            return container.screenKey == key
        }
    }
}

#if canImport(UIKit)
extension ScreenPredicate where Container == UIViewController {

    public static var container: Self {
        container(of: Container.self)
    }

    public static func container(name: String) -> Self {
        container(of: Container.self, name: name)
    }

    public static func container(key: ScreenKey) -> Self {
        container(of: Container.self, key: key)
    }
}

extension ScreenPredicate where Container == UINavigationController {

    public static var stack: Self {
        container(of: Container.self)
    }

    public static func stack(name: String) -> Self {
        container(of: Container.self, name: name)
    }

    public static func stack(key: ScreenKey) -> Self {
        container(of: Container.self, key: key)
    }
}

extension ScreenPredicate where Container == UITabBarController {

    public static var tabs: Self {
        container(of: Container.self)
    }

    public static func tabs(name: String) -> Self {
        container(of: Container.self, name: name)
    }

    public static func tabs(key: ScreenKey) -> Self {
        container(of: Container.self, key: key)
    }
}
#endif
