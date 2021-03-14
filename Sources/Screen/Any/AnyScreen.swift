import Foundation

public struct AnyScreen<Container: ScreenContainer>: Screen {

    public typealias BuildBox = (_ navigator: ScreenNavigator) -> Container

    private let nameBox: () -> String
    private let traitsBox: () -> Set<AnyHashable>
    private let descriptionBox: () -> String
    private let buildBox: (_ navigator: ScreenNavigator) -> Container

    internal init(
        name: @escaping () -> String,
        traits: @escaping () -> Set<AnyHashable>,
        description: @escaping () -> String,
        build: @escaping (_ navigator: ScreenNavigator) -> Container
    ) {
        self.nameBox = name
        self.traitsBox = traits
        self.descriptionBox = description
        self.buildBox = build
    }

    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container == Container {
        self.init(
            name: { wrapped.name },
            traits: { wrapped.traits },
            description: { wrapped.description },
            build: wrapped.build
        )
    }

    public func build(navigator: ScreenNavigator) -> Container {
        buildBox(navigator)
    }
}

extension Screen {

    public func eraseToAnyScreen() -> AnyScreen<Container> {
        AnyScreen(self)
    }
}
