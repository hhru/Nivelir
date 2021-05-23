#if canImport(UIKit)
import UIKit

public struct ScreenShowAlertAction<Container: UIViewController>: ScreenAction {

    public typealias Output = UIAlertController

    public let alert: Alert
    public let animated: Bool

    public init(alert: Alert, animated: Bool = true) {
        self.alert = alert
        self.animated = animated
    }

    private func showAlert(
        _ alertContainer: UIAlertController,
        on container: Container,
        completion: @escaping Completion
    ) {
        container.present(alertContainer, animated: animated) {
            completion(.success(alertContainer))
        }
    }

    private func showAlertUsingPopover(
        _ alertContainer: UIAlertController,
        style: AlertPopoverStyle,
        on container: Container,
        completion: @escaping Completion
    ) {
        guard let popoverPresentationController = alertContainer.popoverPresentationController else {
            return showAlert(
                alertContainer,
                on: container,
                completion: completion
            )
        }

        if let permittedArrowDirections = style.permittedArrowDirections {
            popoverPresentationController.permittedArrowDirections = permittedArrowDirections
        }

        switch style.source {
        case .center:
            popoverPresentationController.sourceRect = CGRect(
                origin: container.view.center,
                size: .zero
            )

            popoverPresentationController.sourceView = container.view

        case let .barButtonItem(barButtonItem):
            popoverPresentationController.barButtonItem = barButtonItem

        case let .rect(rect, view):
            popoverPresentationController.sourceRect = rect
            popoverPresentationController.sourceView = view ?? container.view
        }

        showAlert(
            alertContainer,
            on: container,
            completion: completion
        )
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Presenting \(alert) on \(type(of: container))")

        let alertContainer = UIAlertController(alert: alert)

        switch alert.type {
        case let .actionSheet(popoverStyle)
        where UIDevice.current.userInterfaceIdiom.prefersToPresentUsingPopover:
            showAlertUsingPopover(
                alertContainer,
                style: popoverStyle,
                on: container,
                completion: completion
            )

        case .alert, .actionSheet:
            showAlert(
                alertContainer,
                on: container,
                completion: completion
            )
        }
    }
}

extension ScreenThenable where Then: UIViewController {

    public func showAlert<Route: ScreenThenable>(
        _ alert: Alert,
        animated: Bool = true,
        route: Route
    ) -> Self where Route.Root == UIAlertController {
        nest(
            action: ScreenShowAlertAction<Then>(
                alert: alert,
                animated: animated
            ),
            nested: route
        )
    }

    public func showAlert(
        _ alert: Alert,
        animated: Bool = true,
        route: (_ route: ScreenRoute<UIAlertController>) -> ScreenRoute<UIAlertController> = { $0 }
    ) -> Self {
        showAlert(
            alert,
            animated: animated,
            route: route(.initial)
        )
    }

    public func showAlert<Next: ScreenContainer>(
        _ alert: Alert,
        animated: Bool = true,
        route: (_ route: ScreenRoute<UIAlertController>) -> ScreenChildRoute<UIAlertController, Next>
    ) -> Self {
        showAlert(
            alert,
            animated: animated,
            route: route(.initial)
        )
    }
}
#endif
