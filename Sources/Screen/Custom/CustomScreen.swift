#if canImport(UIKit)
import UIKit

public struct CustomScreen<Container: UIViewController>: Screen, ScreenPayloadAssociating {

    public typealias Builder = (_ navigator: ScreenNavigator) -> Container

    public let builder: Builder

    public init(builder: @escaping Builder) {
        self.builder = builder
    }

    public func build(navigator: ScreenNavigator) -> Container {
        builder(navigator)
    }
}
#endif
