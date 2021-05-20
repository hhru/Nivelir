import Foundation

internal final class AnyScreenActionBox<
    Wrapped: ScreenAction,
    Output
>: AnyScreenActionBaseBox<Wrapped.Container, Output> {

    internal typealias Mapper = (_ result: Result<Wrapped.Output, Error>) -> Result<Output, Error>

    private let wrapped: Wrapped
    private let mapper: Mapper

    internal init(_ wrapped: Wrapped, mapper: @escaping Mapper) {
        self.wrapped = wrapped
        self.mapper = mapper
    }

    internal override func cast<T>(to type: T.Type) -> T? {
        wrapped.cast(to: type)
    }

    internal override func combine<Action: ScreenAction>(
        with other: Action
    ) -> Action? where Action.Container == Container {
        wrapped.combine(with: other)
    }

    internal override func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        wrapped.perform(container: container, navigation: navigation) { result in
            completion(self.mapper(result))
        }
    }
}
