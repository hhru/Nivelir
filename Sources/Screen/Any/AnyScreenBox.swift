import Foundation

internal final class AnyScreenBox<
    Wrapped: Screen,
    Container: ScreenContainer
>: AnyScreenBaseBox<Container> {

    internal typealias Builder = (
        _ screen: Wrapped,
        _ navigator: ScreenNavigator
    ) -> Container

    private let wrapped: Wrapped
    private let builder: Builder

    internal override var name: String {
        wrapped.name
    }

    internal override var traits: Set<AnyHashable> {
        wrapped.traits
    }

    private let _description: String
    internal override var description: String {
        _description
    }

    internal init(_ wrapped: Wrapped, builder: @escaping Builder) {
        self.wrapped = wrapped
        self.builder = builder
        _description = wrapped.description
    }

    internal override func build(navigator: ScreenNavigator) -> Container {
        builder(wrapped, navigator)
    }
}
