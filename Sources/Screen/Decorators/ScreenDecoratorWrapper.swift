import Foundation

internal struct ScreenDecoratorWrapper<
    Wrapped: Screen,
    Decorator: ScreenDecorator
>: Screen where Wrapped.Container == Decorator.Container {

    internal let wrapped: Wrapped
    internal let decorator: Decorator

    internal var key: ScreenKey {
        wrapped.key
    }

    internal var description: String {
        wrapped.description
    }

    internal func build(navigator: ScreenNavigator, associating payload: Any?) -> Decorator.Output {
        let decoratedPayload = decorator.payload.map { decoratorPayload in
            ScreenDecoratorPayload(
                wrapped: payload,
                value: decoratorPayload
            )
        } ?? payload

        return decorator.buildDecorated(
            screen: wrapped,
            navigator: navigator,
            associating: decoratedPayload
        )
    }
}

extension Screen {

    public func decorated<Decorator: ScreenDecorator>(
        by decorator: Decorator
    ) -> AnyScreen<Decorator.Output> where Container == Decorator.Container {
        ScreenDecoratorWrapper(
            wrapped: self,
            decorator: decorator
        ).eraseToAnyScreen()
    }
}
