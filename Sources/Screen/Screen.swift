import Foundation

public protocol Screen: CustomStringConvertible {
    associatedtype Container: ScreenContainer

    func build(
        navigator: ScreenNavigator,
        payload: Any?
    ) -> Container
}

extension Screen {

    public var description: String {
        "\(Self.self)"
    }

    public func build(navigator: ScreenNavigator) -> Container {
        build(
            navigator: navigator,
            payload: nil
        )
    }
}
