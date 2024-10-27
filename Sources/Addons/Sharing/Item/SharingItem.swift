#if canImport(UIKit) && os(iOS)
import UIKit

public enum SharingItem: CustomStringConvertible, @unchecked Sendable {

    case regular(Any)
    case custom(SharingCustomItem)

    public var description: String {
        switch self {
        case let .regular(value):
            return "\(value)"

        case let .custom(value):
            return "\(value)"
        }
    }

    internal var activityItem: Any {
        switch self {
        case let .regular(value):
            return value

        case let .custom(value):
            return SharingItemManager(item: value)
        }
    }

    internal init(activityItem: Any) {
        if let manager = activityItem as? SharingItemManager {
            self = .custom(manager.item)
        } else {
            self = .regular(activityItem)
        }
    }
}
#endif
