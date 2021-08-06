import Foundation

public struct ScreenFailAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public let error: Error

    public init(error: Error) {
        self.error = error
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        completion(.failure(error))
    }
}

extension ScreenThenable {

    public func fail(with error: Error) -> Self {
        then(ScreenFailAction(error: error))
    }
}
