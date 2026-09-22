#if canImport(UIKit)
import UIKit

/// Action that displays the `UIAlertController` in alert style.
public struct ScreenShowAlertAction<Container: UIViewController>: ScreenAction {

    public typealias Output = UIAlertController

    public let alert: Alert
    public let animated: Bool

    public init(alert: Alert, animated: Bool = true) {
        self.alert = alert
        self.animated = animated
    }

    private func addTextField(
        _ textField: AlertTextField,
        to alertContainer: UIAlertController
    ) -> UITextField? {
        var alertTextField: UITextField?

        alertContainer.addTextField { newTextField in
            alertTextField = newTextField

            switch textField {
            case let .standard(text, placeholder):
                newTextField.text = text
                newTextField.placeholder = placeholder

            case let .custom(configuration):
                configuration(newTextField)
            }
        }

        return alertTextField
    }

    private func makeAlertContainer() -> UIAlertController {
        let alertContainer = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert
        )

        if let tintColor = alert.tintColor {
            alertContainer.view.tintColor = tintColor
        }

        if let accessibilityIdentifier = alert.accessibilityIdentifier {
            alertContainer.view.accessibilityIdentifier = accessibilityIdentifier
        }

        let textFields = alert
            .textFields
            .map { addTextField($0, to: alertContainer) }

        let actions = alert
            .actions
            .map { action in
                UIAlertAction(title: action.title, style: action.style) { _ in
                    action.handler?(textFields.map { $0?.text ?? "" })
                }
            }

        let textFieldsManager = AlertTextFieldsManager(textFields: textFields) { texts in
            actions
                .enumerated()
                .forEach { index, action in
                    action.isEnabled = alert.actions[index].enabler?(texts) ?? true
                }
        }

        alertContainer.screenPayload.store(textFieldsManager)

        actions.forEach { action in
            alertContainer.addAction(action)
        }

        return alertContainer
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Presenting \(alert) on \(type(of: container))")

        guard container.presented == nil else {
            return completion(.containerAlreadyPresenting(container, for: self))
        }

        let alertContainer = makeAlertContainer()

        container.present(alertContainer, animated: animated) {
            completion(.success(alertContainer))
        }
    }
}

extension ScreenThenable where Current: UIViewController {

    /// Presents an alert to the user.
    ///
    /// Use this method when you need to show an alert to the user.
    /// The example below displays an alert with single default action:
    ///
    /// ```swift
    /// let navigator: ScreenNavigator
    ///
    /// let alert = Alert(
    ///     title: "Order Complete",
    ///     message: "Thank you for shopping with us.",
    ///     actions: AlertAction(title: "OK")
    /// )
    ///
    /// navigator.navigate(from: self) { route in
    ///     route.showAlert(alert)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - alert: The alert to present.
    ///   - animated: Pass `true` to animate the presentation; otherwise, pass `false`.
    /// - Returns: An instance containing the new action.
    public func showAlert(
        _ alert: Alert,
        animated: Bool = true
    ) -> Self {
        then(
            ScreenShowAlertAction<Current>(
                alert: alert,
                animated: animated
            )
        )
    }
}
#endif
