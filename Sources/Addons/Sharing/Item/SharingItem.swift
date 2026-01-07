#if canImport(UIKit) && os(iOS)
import UIKit

@frozen
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
        switch activityItem {
        case let item as SharingCustomItem:
            self = .custom(item)

        case let manager as SharingItemManager:
            self = .custom(manager.item)

        default:
            self = .regular(activityItem)
        }
    }
}
#endif
