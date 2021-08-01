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

    internal override var description: String {
        wrapped.description
    }

    internal init(_ wrapped: Wrapped, builder: @escaping Builder) {
        self.wrapped = wrapped
        self.builder = builder
    }

    internal override func build(navigator: ScreenNavigator) -> Container {
        builder(wrapped, navigator)
    }
}
