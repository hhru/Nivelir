#if canImport(UIKit)
import UIKit

public final class DefaultScreenNavigator: ScreenNavigator {

    private let windowProvider: ScreenWindowProvider
    private let iterator: ScreenIterator
    private let logger: ScreenLogger?

    public init(
        windowProvider: ScreenWindowProvider = ScreenKeyWindowProvider(),
        iterator: ScreenIterator = DefaultScreenIterator(),
        logger: ScreenLogger? = DefaultScreenLogger()
    ) {
        self.windowProvider = windowProvider
        self.iterator = iterator
        self.logger = logger
    }

    private func perform<Action: ScreenAction>(
        action: Action,
        completion: @escaping Action.Completion
    ) where Action.Container == UIWindow {
        guard let window = windowProvider.window else {
            return completion(.containerNotFound(type: UIWindow.self, for: self))
        }

        let navigation = ScreenNavigation(
            navigator: self,
            iterator: iterator,
            logger: logger
        )

        action.perform(
            container: window,
            navigation: navigation,
            completion: completion
        )
    }

    public func perform<Action: ScreenAction>(
        action: Action,
        completion: Completion?
    ) where Action.Container == UIWindow {
        perform(action: action) { [weak self] result in
            switch result {
            case .success:
                completion?(.success)

            case let .failure(error):
                self?.logger?.error(error)
                completion?(.failure(error))
            }
        }
    }
}
#endif
