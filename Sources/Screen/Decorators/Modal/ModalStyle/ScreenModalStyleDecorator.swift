#if canImport(UIKit)
import UIKit

public struct ScreenModalStyleDecorator<Container: UIViewController>: ScreenDecorator {

    public let style: ScreenModalStyle

    public var payload: Any? {
        switch style {
        case .default:
            return nil

        case let .custom(delegate):
            return delegate
        }
    }

    public init(style: ScreenModalStyle) {
        self.style = style
    }

    public func buildDecorated<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator,
        associating payload: Any?
    ) -> Container where Wrapped.Container == Container {
        let container = screen.build(
            navigator: navigator,
            associating: payload
        )

        switch style {
        case let .default(presentationStyle, transitionStyle):
            if let presentationStyle = presentationStyle {
                container.modalPresentationStyle = presentationStyle
            }

            if let transitionStyle = transitionStyle {
                container.modalTransitionStyle = transitionStyle
            }

        case let .custom(delegate):
            container.modalPresentationStyle = .custom
            container.transitioningDelegate = delegate
        }

        return container
    }
}

extension Screen where Container: UIViewController {

    public func withModalStyle(_ style: ScreenModalStyle) -> AnyScreen<Container> {
        decorated(by: ScreenModalStyleDecorator(style: style))
    }

    public func withPresentationStyle(_ style: UIModalPresentationStyle) -> AnyScreen<Container> {
        withModalStyle(.default(presentation: style))
    }

    public func withTransitionStyle(_ style: UIModalTransitionStyle) -> AnyScreen<Container> {
        withModalStyle(.default(transition: style))
    }

    public func withTransitionDelegate(
        _ delegate: UIViewControllerTransitioningDelegate
    ) -> AnyScreen<Container> {
        withModalStyle(.custom(delegate: delegate))
    }
}
#endif
