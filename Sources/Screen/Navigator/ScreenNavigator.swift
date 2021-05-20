#if canImport(UIKit)
import UIKit
#else
import Foundation
#endif

public final class ScreenNavigator {

    public typealias Completion = (Result<Void, Error>) -> Void

    #if canImport(UIKit)
    private let windowProvider: ScreenWindowProvider
    #endif

    private let builder: ScreenBuilder
    private let iterator: ScreenIterator
    private let logger: ScreenLogger?

    #if canImport(UIKit)
    public init(
        windowProvider: ScreenWindowProvider,
        builder: ScreenBuilder = DefaultScreenBuilder(),
        iterator: ScreenIterator = DefaultScreenIterator(),
        logger: ScreenLogger? = DefaultScreenLogger()
    ) {
        self.windowProvider = windowProvider
        self.builder = builder
        self.iterator = iterator
        self.logger = logger
    }

    public convenience init(
        window: UIWindow,
        interceptors: [ScreenInterceptor],
        iterator: ScreenIterator = DefaultScreenIterator(),
        logger: ScreenLogger? = DefaultScreenLogger()
    ) {
        self.init(
            windowProvider: ScreenCustomWindowProvider(window: window),
            builder: DefaultScreenBuilder(interceptors: interceptors),
            iterator: iterator,
            logger: logger
        )
    }
    #else
    public init(
        builder: ScreenBuilder,
        iterator: ScreenIterator,
        logger: ScreenLogger?
    ) {
        self.builder = builder
        self.iterator = iterator
        self.logger = logger
    }
    #endif

    #if canImport(UIKit)
    private func perform<Action: ScreenAction>(
        action: Action,
        completion: @escaping Action.Completion
    ) where Action.Container == UIWindow {
        guard let window = windowProvider.window else {
            return completion(.containerNotFound(type: UIWindow.self, for: self))
        }

        let navigation = ScreenNavigation(
            navigator: self,
            builder: builder,
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
    #endif
}
