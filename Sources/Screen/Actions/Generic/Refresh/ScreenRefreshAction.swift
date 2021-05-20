import Foundation

public struct ScreenRefreshAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public init() { }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        guard let refreshableContainer = container as? ScreenRefreshableContainer else {
            return completion(.invalidContainer(container, type: ScreenRefreshableContainer.self, for: self))
        }

        refreshableContainer.refresh { completion(.success) }
    }
}

extension ScreenThenable {

    public func refresh() -> Self {
        then(ScreenRefreshAction())
    }
}
