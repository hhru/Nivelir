#if canImport(UIKit)
import UIKit

public struct ScreenSelectTabPredicate<Container: UITabBarController> {

    private let box: (_ tabs: [UIViewController]) -> Int?

    public init(_ box: @escaping (_ tabs: [UIViewController]) -> Int?) {
        self.box = box
    }

    public func tabIndex(in tabs: [UIViewController]) -> Int? {
        box(tabs)
    }
}

extension ScreenSelectTabPredicate {

    public static func index(_ index: Int) -> Self {
        Self { _ in index }
    }

    public static func container(_ container: UIViewController) -> Self {
        Self { tabs in
            tabs.firstIndex { $0 === container }
        }
    }

    public static func container(key: ScreenKey) -> Self {
        Self { tabs in
            tabs
                .map { $0 as? ScreenKeyProvider }
                .firstIndex { $0?.screenKey == key }
        }
    }
}
#endif
