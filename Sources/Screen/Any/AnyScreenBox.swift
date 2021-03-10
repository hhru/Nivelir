import Foundation

internal struct AnyScreenBox<Container: ScreenContainer> {

    internal let description: () -> String

    internal let build: (
        _ navigator: ScreenNavigator,
        _ payload: Any?
    ) -> Container
}
