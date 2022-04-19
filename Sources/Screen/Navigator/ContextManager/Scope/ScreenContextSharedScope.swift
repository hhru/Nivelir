import Foundation

internal struct ScreenContextSharedScope: ScreenContextScope {

    internal static let `default` = Self()

    private init() { }

    internal func makeStorage(for context: AnyObject) -> ScreenContextStorage {
        ScreenContextSharedStorage(context: context)
    }
}
