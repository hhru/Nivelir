import Foundation

public protocol Screen {
    associatedtype Container: ScreenContainer

    var name: String { get }
    var traits: Set<AnyHashable> { get }

    func build(navigator: ScreenNavigator) -> Container
}

extension Screen {

    public var name: String {
        "\(Self.self)"
    }

    public var traits: Set<AnyHashable> {
        []
    }

    public var description: String {
        key.name
    }

    public var key: ScreenKey {
        ScreenKey(name: name, traits: traits)
    }
}
