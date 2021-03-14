import Foundation

public protocol ScreenKeyedContainer: ScreenContainer {
    var screenKey: ScreenKey { get }
}

extension ScreenKeyedContainer {

    public var screenName: String {
        screenKey.name
    }

    public var screenTraits: Set<AnyHashable> {
        screenKey.traits
    }
}
