import Foundation

internal struct ScreenObservationStorage {

    internal private(set) weak var value: AnyObject?

    internal init(_ value: AnyObject) {
        self.value = value
    }
}
