import Foundation

public protocol Screen: CustomStringConvertible {
    associatedtype Container: ScreenContainer

    var key: ScreenKey { get }

    func build(
        navigator: ScreenNavigator,
        associating payload: Any?
    ) -> Container
}

extension Screen {

    public var key: ScreenKey {
        .default(type: Self.self)
    }

    public var description: String {
        "\(key)"
    }

    public func build(navigator: ScreenNavigator) -> Container {
        build(
            navigator: navigator,
            associating: nil
        )
    }
}
