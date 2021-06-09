#if canImport(UIKit)
import UIKit

public struct ScreenShowActionSheetAction<Container: UIViewController>: ScreenAction {

    public typealias Output = UIAlertController

    public let actionSheet: ActionSheet
    public let animated: Bool

    public init(actionSheet: ActionSheet, animated: Bool = true) {
        self.actionSheet = actionSheet
        self.animated = animated
    }

    private func showAlertContainer(
        _ alertContainer: UIAlertController,
        in container: Container,
        completion: @escaping Completion
    ) {
        container.present(alertContainer, animated: animated) {
            completion(.success(alertContainer))
        }
    }

    private func showAlertContainerUsingPopover(
        _ alertContainer: UIAlertController,
        from source: ScreenPopoverPresentationAnchor,
        in container: Container,
        completion: @escaping Completion
    ) {
        guard let popoverPresentationController = alertContainer.popoverPresentationController else {
            return showAlertContainer(
                alertContainer,
                in: container,
                completion: completion
            )
        }

        if let permittedArrowDirections = source.permittedArrowDirections {
            popoverPresentationController.permittedArrowDirections = permittedArrowDirections
        }

        popoverPresentationController.sourceRect = source.rect ?? CGRect(
            x: container.view.bounds.midX,
            y: container.view.bounds.midY,
            width: .zero,
            height: .zero
        )

        popoverPresentationController.sourceView = source.view ?? container.view
        popoverPresentationController.barButtonItem = source.barButtonItem

        showAlertContainer(
            alertContainer,
            in: container,
            completion: completion
        )
    }

    private func makeAlertContainer() -> UIAlertController {
        let alertContainer = UIAlertController(
            title: actionSheet.title,
            message: actionSheet.message,
            preferredStyle: .actionSheet
        )

        if let tintColor = actionSheet.tintColor {
            alertContainer.view.tintColor = tintColor
        }

        if let accessibilityIdentifier = actionSheet.accessibilityIdentifier {
            alertContainer.view.accessibilityIdentifier = accessibilityIdentifier
        }

        let actions = actionSheet
            .actions
            .map { action in
                UIAlertAction(title: action.title, style: action.style) { _ in
                    action.handler?()
                }
            }

        actions.forEach { alertContainer.addAction($0) }

        return alertContainer
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Presenting \(actionSheet) on \(type(of: container))")

        let alertContainer = makeAlertContainer()

        switch UIDevice.current.userInterfaceIdiom {
        case .pad, .mac:
            showAlertContainerUsingPopover(
                alertContainer,
                from: actionSheet.anchor,
                in: container,
                completion: completion
            )

        case .phone, .tv, .carPlay, .unspecified:
            showAlertContainer(
                alertContainer,
                in: container,
                completion: completion
            )

        @unknown default:
            showAlertContainer(
                alertContainer,
                in: container,
                completion: completion
            )
        }
    }
}

extension ScreenRoute where Current: UIViewController {

    public func showActionSheet(
        _ actionSheet: ActionSheet,
        animated: Bool = true
    ) -> Self {
        then(
            ScreenShowActionSheetAction<Current>(
                actionSheet: actionSheet,
                animated: animated
            )
        )
    }
}
#endif
