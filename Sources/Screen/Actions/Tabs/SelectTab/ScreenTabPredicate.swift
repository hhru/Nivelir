#if canImport(UIKit)
import UIKit

@MainActor
public struct ScreenTabPredicate: CustomStringConvertible {

    public let description: String

    private let box: (_ tabs: [UIViewController]) -> Int?

    public init(
        description: String,
        _ box: @escaping (_ tabs: [UIViewController]) -> Int?
    ) {
        self.description = description
        self.box = box
    }

    public func tabIndex(in tabs: [UIViewController]) -> Int? {
        box(tabs)
    }
}

extension ScreenTabPredicate {

    public static func index(_ index: Int) -> Self {
        Self(description: "index \(index)") { _ in index }
    }

    public static func container(_ container: UIViewController) -> Self {
        Self(description: "given container") { tabs in
            tabs.firstIndex { $0 === container }
        }
    }

    public static func container(name: String) -> Self {
        Self(description: "\(name) container") { tabs in
            tabs
                .map { $0 as? ScreenKeyedContainer }
                .firstIndex { $0?.screenKey.name == name }
        }
    }

    public static func container(key: ScreenKey) -> Self {
        Self(description: "\(key) container") { tabs in
            tabs
                .map { $0 as? ScreenKeyedContainer }
                .firstIndex { $0?.screenKey == key }
        }
    }
}
#endif
