import Foundation

public protocol ScreenAction: AnyScreenAction {
    associatedtype Container: ScreenContainer
    associatedtype Output

    typealias Completion = (Result<Output, Error>) -> Void

    func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    )
}

extension ScreenAction {

    public func performIfPossible(
        container: ScreenContainer,
        navigation: ScreenNavigation,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let container = container as? Container else {
            return completion(.failure(ScreenInvalidContainerError<Container>(for: self)))
        }

        return perform(container: container, navigation: navigation) { result in
            completion(result.ignoringValue())
        }
    }
}
