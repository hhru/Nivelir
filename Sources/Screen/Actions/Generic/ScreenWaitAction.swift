import Foundation

public struct ScreenWaitAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public let timeout: TimeInterval

    public init(timeout: TimeInterval) {
        self.timeout = timeout
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            completion(.success)
        }
    }
}

extension ScreenRoute {

    public func wait(timeout: TimeInterval) -> Self {
        then(ScreenWaitAction(timeout: timeout))
    }
}
