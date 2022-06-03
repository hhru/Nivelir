import Foundation

internal struct ScreenContainerSharedStorage: ScreenContainerStorage {

    private let container: ScreenContainer

    internal var value: ScreenContainer? {
        container
    }

    internal init(_ container: ScreenContainer) {
        self.container = container
    }
}
