import Foundation

public struct CustomScreen<Container: ScreenContainer>: Screen {

    public typealias Builder = (
        _ navigator: ScreenNavigator,
        _ payload: Any?
    ) -> Container

    public let key: ScreenKey
    public let builder: Builder

    public init(
        key: ScreenKey = .default(type: type(of: Self.self)),
        builder: @escaping Builder
    ) {
        self.key = key
        self.builder = builder
    }

    public func build(navigator: ScreenNavigator, associating payload: Any?) -> Container {
        builder(navigator, payload)
    }
}
