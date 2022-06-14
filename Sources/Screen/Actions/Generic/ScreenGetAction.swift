import Foundation

public struct ScreenGetAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public typealias Body = (
        _ container: Container,
        _ completion: () -> Void
    ) -> Void

    public let body: Body

    public init(body: @escaping Body) {
        self.body = body
    }

    public init(body: @escaping (_ container: Container) -> Void) {
        self.init { container, completion in
            body(container)
            completion()
        }
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        body(container) { completion(.success) }
    }
}

extension ScreenThenable {

    public func get(body: @escaping ScreenGetAction<Current>.Body) -> Self {
        then(ScreenGetAction(body: body))
    }

    public func get(body: @escaping (_ container: Current) -> Void) -> Self {
        then(ScreenGetAction(body: body))
    }
}
