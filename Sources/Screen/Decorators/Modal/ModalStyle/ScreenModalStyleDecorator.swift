#if canImport(UIKit)
import UIKit

/// Configuring the modal screen presentation for a container with type `UIViewController`.
///
/// - SeeAlso: `ScreenModalStyle`
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
            if let presentationStyle {
                container.modalPresentationStyle = presentationStyle
            }

            if let transitionStyle {
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

    /// Configuring the modal screen presentation.
    ///
    /// - Parameter style: Type of modal presentation style.
    /// - Returns: New `Screen`, which will be animated with the selected style when presented.
    public func withModalStyle(_ style: ScreenModalStyle) -> AnyScreen<Container> {
        decorated(by: ScreenModalStyleDecorator(style: style))
    }

    /// Sets the `modalPresentationStyle` of `UIViewController` property for the container.
    /// - Parameter style: Modal presentation styles available when presenting view controllers.
    /// - Returns: New `Screen` with the `modalPresentationStyle` property set.
    ///
    /// - SeeAlso: `UIModalPresentationStyle`
    public func withModalPresentationStyle(_ style: UIModalPresentationStyle) -> AnyScreen<Container> {
        withModalStyle(.default(presentation: style))
    }

    /// Sets the `modalTransitionStyle` of `UIViewController` property for the container.
    /// - Parameter style: Transition styles available when presenting view controllers.
    /// - Returns: New `Screen` with the `modalTransitionStyle` property set.
    ///
    /// - SeeAlso: `UIModalTransitionStyle`
    public func withModalTransitionStyle(_ style: UIModalTransitionStyle) -> AnyScreen<Container> {
        withModalStyle(.default(transition: style))
    }

    /// Sets the `transitioningDelegate` of `UIViewController` property for the container.
    /// Also, the `modalPresentationStyle` property will be set to `.custom`.
    ///
    /// Usage example, where `CardModalTransitionAnimator` is an
    /// implementation of the `UIViewControllerTransitioningDelegate` protocol:
    ///
    /// ```swift
    /// navigator.navigate(from: container) { route in
    ///    route.present(
    ///        ChatScreen(chatID: 1)
    ///            .withModalTransitioningDelegate(CardModalTransitionAnimator())
    ///    )
    /// }
    /// ```
    ///
    /// - Parameter delegate: `UIViewControllerTransitioningDelegate` protocol
    /// implementation for custom modal screen presentation.
    /// The implementation class can be safely initialized in the parameter by the place of use,
    /// even though the `transitioningDelegate` property is weak.
    /// The lifecycle of the implementation class will correspond to the lifecycle of the screen container.
    ///
    /// - Returns: New `Screen` with the `transitioningDelegate` property set.
    public func withModalTransitioningDelegate(
        _ delegate: UIViewControllerTransitioningDelegate
    ) -> AnyScreen<Container> {
        withModalStyle(.custom(delegate: delegate))
    }
}
#endif
