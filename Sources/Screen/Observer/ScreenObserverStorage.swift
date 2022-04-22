import Foundation

internal struct ScreenObserverStorage: Hashable {

    private weak var value: AnyObject?

    internal var observer: AnyObject? {
        value
    }

    internal init(_ observer: AnyObject) {
        value = observer
    }

    internal func hash(into hasher: inout Hasher) {
        hasher.combine("\(type(of: value))")
    }
}

extension ScreenObserverStorage {

    internal static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value === rhs.value
    }
}
