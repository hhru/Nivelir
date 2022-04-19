import Foundation

internal struct ScreenContextSharedStorage: ScreenContextStorage {

    internal let context: AnyObject?

    internal init(context: AnyObject) {
        self.context = context
    }
}
