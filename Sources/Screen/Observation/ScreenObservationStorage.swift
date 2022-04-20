import Foundation

internal struct ScreenObservationStorage: Hashable {

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

extension ScreenObservationStorage {

    internal static func == (lhs: Self, rhs: Self) -> Bool {
        type(of: lhs.value) == type(of: rhs.value) && lhs.value === rhs.value
    }
}
