import Foundation

public protocol Screen: CustomStringConvertible {
    associatedtype Container: ScreenContainer

    var name: String { get }
    var traits: Set<AnyHashable> { get }

    func cast<T>(to type: T.Type) -> T?

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

    public func cast<T>(to type: T.Type) -> T? {
        self as? T
    }
}
