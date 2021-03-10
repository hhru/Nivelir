import Foundation

public protocol KeyedScreen: Screen where Container: KeyedScreenContainer {
    var key: ScreenKey { get }

    func build(
        navigator: ScreenNavigator,
        data: KeyedScreenData
    ) -> Container
}

extension KeyedScreen {

    public func build(navigator: ScreenNavigator, payload: Any?) -> Container {
        build(
            navigator: navigator,
            data: KeyedScreenData(
                key: key,
                payload: payload
            )
        )
    }
}
