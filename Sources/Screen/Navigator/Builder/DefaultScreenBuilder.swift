import Foundation

public final class DefaultScreenBuilder: ScreenBuilder {

    public let interceptors: [ScreenInterceptor]

    public init(interceptors: [ScreenInterceptor] = []) {
        self.interceptors = interceptors
    }

    private func performInterceptors<New: Screen>(
        from index: Int = .zero,
        for screen: New,
        navigator: ScreenNavigator,
        completion: @escaping ScreenInterceptor.Completion
    ) {
        guard index < interceptors.count else {
            return completion(.success)
        }

        interceptors[index].interceptScreen(screen, navigator: navigator) { result in
            switch result {
            case .success:
                self.performInterceptors(
                    from: index + 1,
                    for: screen,
                    navigator: navigator,
                    completion: completion
                )

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    public func buildScreen<New: Screen>(
        _ screen: New,
        navigator: ScreenNavigator,
        completion: @escaping (_ result: Result<New.Container, Error>) -> Void
    ) {
        performInterceptors(for: screen, navigator: navigator) { result in
            switch result {
            case .success:
                completion(.success(screen.build(navigator: navigator)))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
