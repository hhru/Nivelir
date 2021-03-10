import Foundation

public protocol KeyedScreenContainer: ScreenContainer, ScreenKeyProvider {
    var screenData: KeyedScreenData { get }
}

extension KeyedScreenContainer {

    public var screenKey: ScreenKey {
        screenData.key
    }
}
