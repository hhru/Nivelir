import Foundation

internal struct ScreenContextWeakScope: ScreenContextScope {

    internal static let `default` = Self()

    private init() { }

    internal func makeStorage(for context: AnyObject) -> ScreenContextStorage {
        ScreenContextWeakStorage(context: context)
    }
}
