#if canImport(UIKit)
import UIKit

public struct ScreenPresentAction<
    New: Screen,
    Container: UIViewController
>: ScreenAction where New.Container: UIViewController {

    public typealias Output = New.Container

    public let screen: New
    public let animated: Bool

    public init(screen: New, animated: Bool = true) {
        self.screen = screen
        self.animated = animated
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        navigation.logger?.info("Presenting \(screen) on \(container)")

        let output = screen.build(navigator: navigation.navigator)

        container.present(output, animated: animated) {
            completion(.success(output))
        }
    }
}

extension ScreenRoute where Container: UIViewController {

    public func present<New: Screen>(
        _ screen: New,
        animated: Bool = true,
        route: ScreenRoute<New.Container>
    ) -> Self where New.Container: UIViewController {
        join(
            action: ScreenPresentAction<New, Container>(
                screen: screen,
                animated: animated
            ),
            route: route
        )
    }

    public func present<New: Screen>(
        _ screen: New,
        animated: Bool = true,
        route: (_ route: ScreenRoute<New.Container>) -> ScreenRoute<New.Container> = { $0 }
    ) -> Self where New.Container: UIViewController {
        present(
            screen,
            animated: animated,
            route: route(.initial)
        )
    }
}
#endif
