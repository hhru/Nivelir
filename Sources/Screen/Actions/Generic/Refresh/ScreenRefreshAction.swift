import Foundation

public struct ScreenRefreshAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        guard let refreshableContainer = container as? ScreenRefreshableContainer else {
            return completion(.containerTypeMismatch(container, type: ScreenRefreshableContainer.self, for: self))
        }

        refreshableContainer.refresh { completion(.success) }
    }
}

extension ScreenRoute {

    public func refresh() -> Self {
        then(ScreenRefreshAction())
    }
}
