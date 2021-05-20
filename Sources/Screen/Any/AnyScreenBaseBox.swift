import Foundation

internal class AnyScreenBaseBox<Container: ScreenContainer>: Screen {

    internal var name: String {
        fatalError("\(#function) has not been implemented")
    }

    internal var traits: Set<AnyHashable> {
        fatalError("\(#function) has not been implemented")
    }

    internal var description: String {
        fatalError("\(#function) has not been implemented")
    }

    // swiftlint:disable:next unavailable_function
    internal func cast<T>(to type: T.Type) -> T? {
        fatalError("\(#function) has not been implemented")
    }

    // swiftlint:disable:next unavailable_function
    internal func build(navigator: ScreenNavigator) -> Container {
        fatalError("\(#function) has not been implemented")
    }
}
