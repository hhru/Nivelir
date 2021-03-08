#if canImport(UIKit)
import UIKit

public struct ScreenStackPopToPredicate {

    private let box: (_ stack: [UIViewController]) -> Int?

    public init(_ box: @escaping (_ stack: [UIViewController]) -> Int?) {
        self.box = box
    }

    internal func containerIndex(in stack: [UIViewController]) -> Int? {
        box(stack)
    }
}

extension ScreenStackPopToPredicate {

    public static func container(_ container: UIViewController) -> Self {
        Self { stack in
            stack.lastIndex { $0 === container }
        }
    }

    public static func container(key: ScreenKey) -> Self {
        Self { stack in
            stack
                .map { $0 as? ScreenInfoContainer }
                .lastIndex { $0?.screenInfo.key == key }
        }
    }
}
#endif
