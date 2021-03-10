#if canImport(UIKit)
import UIKit

public struct CustomKeyedScreen<Container: UIViewController & KeyedScreenContainer>: KeyedScreen {

    public typealias Builder = (
        _ navigator: ScreenNavigator,
        _ data: KeyedScreenData
    ) -> Container

    public let key: ScreenKey
    public let builder: Builder

    public init(key: ScreenKey, builder: @escaping Builder) {
        self.key = key
        self.builder = builder
    }

    public func build(navigator: ScreenNavigator, data: KeyedScreenData) -> Container {
        builder(navigator, data)
    }
}
#endif
