import Foundation

public struct ScreenNavigation {

    public let navigator: ScreenNavigator
    public let iterator: ScreenIterator
    public let logger: ScreenLogger?

    public init(
        navigator: ScreenNavigator,
        iterator: ScreenIterator,
        logger: ScreenLogger?
    ) {
        self.navigator = navigator
        self.iterator = iterator
        self.logger = logger
    }
}
