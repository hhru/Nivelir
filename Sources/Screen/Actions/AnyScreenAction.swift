import Foundation

public protocol AnyScreenAction {
    func combine(with other: AnyScreenAction) -> [AnyScreenAction]

    func performIfPossible(
        container: ScreenContainer,
        navigation: ScreenNavigation,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

extension AnyScreenAction {

    public var description: String? {
        nil
    }

    public func combine(with other: AnyScreenAction) -> [AnyScreenAction] {
        [self, other]
    }
}
