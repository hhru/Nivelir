import Foundation

internal final class AnyScreenActionBox<
    Wrapped: ScreenAction,
    Output
>: AnyScreenActionBaseBox<Wrapped.Container, Output> {

    internal typealias Mapper = (_ result: Result<Wrapped.Output, Error>) -> Result<Output, Error>

    private let wrapped: Wrapped
    private let mapper: Mapper

    private let _description: String
    internal override var description: String {
        _description
    }

    internal init(_ wrapped: Wrapped, mapper: @escaping Mapper) {
        self.wrapped = wrapped
        self.mapper = mapper
        _description = "\(wrapped)"
    }

    internal override func cast<Action: ScreenAction>(to type: Action.Type) -> Action? {
        wrapped.cast(to: type)
    }

    internal override func combine<Action: ScreenAction>(
        with other: Action
    ) -> AnyScreenAction<Container, Void>? {
        wrapped.combine(with: other)
    }

    internal override func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        wrapped.perform(container: container, navigator: navigator) { result in
            completion(self.mapper(result))
        }
    }
}
