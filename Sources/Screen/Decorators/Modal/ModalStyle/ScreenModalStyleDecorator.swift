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

    public var description: String {
        "ModalStyleDecorator"
    }

    public init(style: ScreenModalStyle) {
        self.style = style
    }

    public func build<Wrapped: Screen>(
        screen: Wrapped,
        navigator: ScreenNavigator
    ) -> Container where Wrapped.Container == Container {
        let container = screen.build(navigator: navigator)

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

    public func withModalPresentationStyle(_ style: UIModalPresentationStyle) -> AnyScreen<Container> {
        withModalStyle(.default(presentation: style))
    }

    public func withModalTransitionStyle(_ style: UIModalTransitionStyle) -> AnyScreen<Container> {
        withModalStyle(.default(transition: style))
    }

    public func withModalTransitioningDelegate(
        _ delegate: UIViewControllerTransitioningDelegate
    ) -> AnyScreen<Container> {
        withModalStyle(.custom(delegate: delegate))
    }
}
#endif
