#if canImport(UIKit)
import UIKit

public struct ScreenTabPredicate {

    private let box: (_ tabs: [UIViewController]) -> Int?

    public init(_ box: @escaping (_ tabs: [UIViewController]) -> Int?) {
        self.box = box
    }

    public func tabIndex(in tabs: [UIViewController]) -> Int? {
        box(tabs)
    }
}

extension ScreenTabPredicate {

    public static func index(_ index: Int) -> Self {
        Self { _ in index }
    }

    public static func container(_ container: UIViewController) -> Self {
        Self { tabs in
            tabs.firstIndex { $0 === container }
        }
    }

    public static func container(name: String) -> Self {
        Self { tabs in
            tabs
                .map { $0 as? ScreenKeyedContainer }
                .firstIndex { $0?.screenName == name }
        }
    }

    public static func container(key: ScreenKey) -> Self {
        Self { tabs in
            tabs
                .map { $0 as? ScreenKeyedContainer }
                .firstIndex { $0?.screenKey == key }
        }
    }
}
#endif
