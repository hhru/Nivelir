import Foundation

internal struct ScreenContextWeakStorage: ScreenContextStorage {

    private weak var value: AnyObject?

    internal var context: AnyObject? {
        value
    }

    internal init(context: AnyObject) {
        value = context
    }
}
