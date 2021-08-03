#if canImport(UIKit)
import UIKit

public struct ScreenStackPopPredicate: CustomStringConvertible {

    public let description: String

    private let box: (_ stack: [UIViewController]) -> Int?

    public init(
        description: String,
        _ box: @escaping (_ stack: [UIViewController]) -> Int?
    ) {
        self.description = description
        self.box = box
    }

    internal func containerIndex(in stack: [UIViewController]) -> Int? {
        box(stack)
    }
}

extension ScreenStackPopPredicate {

    public static var root: Self {
        Self(description: "to root") { _ in 0 }
    }

    public static var previous: Self {
        Self(description: "") { stack in
            max(stack.count - 2, 0)
        }
    }

    public static func container(_ container: UIViewController) -> Self {
        Self(description: "to given container") { stack in
            stack.lastIndex { $0 === container }
        }
    }

    public static func container(name: String) -> Self {
        Self(description: "to \(name) container") { stack in
            stack
                .map { $0 as? ScreenKeyedContainer }
                .lastIndex { $0?.screenKey.name == name }
        }
    }

    public static func container(key: ScreenKey) -> Self {
        Self(description: "to \(key) container") { stack in
            stack
                .map { $0 as? ScreenKeyedContainer }
                .lastIndex { $0?.screenKey == key }
        }
    }
}
#endif
