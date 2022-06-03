import Foundation

internal struct ScreenContainerWeakStorage: ScreenContainerStorage {

    internal typealias Container = AnyObject & ScreenContainer

    private weak var container: Container?

    internal var value: ScreenContainer? {
        container
    }

    internal init(_ container: Container) {
        self.container = container
    }
}
