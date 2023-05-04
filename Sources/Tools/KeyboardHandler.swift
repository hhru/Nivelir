#if canImport(UIKit) && os(iOS)
import UIKit

internal protocol KeyboardHandler: AnyObject {

    var keyboardFrame: CGRect { get set }

    var keyboardWillShowNotificationObserver: NotificationObserver? { get set }
    var keyboardDidShowNotificationObserver: NotificationObserver? { get set }

    var keyboardWillChangeFrameNotificationObserver: NotificationObserver? { get set }
    var keyboardDidChangeFrameNotificationObserver: NotificationObserver? { get set }

    var keyboardWillHideNotificationObserver: NotificationObserver? { get set }
    var keyboardDidHideNotificationObserver: NotificationObserver? { get set }

    func handleKeyboardFrame(
        _ keyboardFrame: CGRect,
        animationDuration: TimeInterval,
        animationOptions: UIView.AnimationOptions
    )
}

private let keyboardFrameAssociation = ObjectAssociation<CGRect>()

private let keyboardWillShowNotificationAssociation = ObjectAssociation<NotificationObserver>()
private let keyboardDidShowNotificationAssociation = ObjectAssociation<NotificationObserver>()

private let keyboardWillChangeFrameNotificationAssociation = ObjectAssociation<NotificationObserver>()
private let keyboardDidChangeFrameNotificationAssociation = ObjectAssociation<NotificationObserver>()

private let keyboardWillHideNotificationAssociation = ObjectAssociation<NotificationObserver>()
private let keyboardDidHideNotificationAssociation = ObjectAssociation<NotificationObserver>()

extension KeyboardHandler where Self: NSObject {

    internal var keyboardFrame: CGRect {
        get { keyboardFrameAssociation[self] ?? .zero }
        set { keyboardFrameAssociation[self] = newValue }
    }

    internal var keyboardWillShowNotificationObserver: NotificationObserver? {
        get { keyboardWillShowNotificationAssociation[self] }
        set { keyboardWillShowNotificationAssociation[self] = newValue }
    }

    internal var keyboardDidShowNotificationObserver: NotificationObserver? {
        get { keyboardDidShowNotificationAssociation[self] }
        set { keyboardDidShowNotificationAssociation[self] = newValue }
    }

    internal var keyboardWillChangeFrameNotificationObserver: NotificationObserver? {
        get { keyboardWillChangeFrameNotificationAssociation[self] }
        set { keyboardWillChangeFrameNotificationAssociation[self] = newValue }
    }

    internal var keyboardDidChangeFrameNotificationObserver: NotificationObserver? {
        get { keyboardDidChangeFrameNotificationAssociation[self] }
        set { keyboardDidChangeFrameNotificationAssociation[self] = newValue }
    }

    internal var keyboardWillHideNotificationObserver: NotificationObserver? {
        get { keyboardWillHideNotificationAssociation[self] }
        set { keyboardWillHideNotificationAssociation[self] = newValue }
    }

    internal var keyboardDidHideNotificationObserver: NotificationObserver? {
        get { keyboardDidHideNotificationAssociation[self] }
        set { keyboardDidHideNotificationAssociation[self] = newValue }
    }
}

extension KeyboardHandler {

    private func resolveKeyboardFrame(from notification: Notification) -> CGRect {
        notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            .flatMap { $0 as? NSValue }
            .map { $0.cgRectValue } ?? .zero
    }

    private func resolveKeyboardAnimationDuration(from notification: Notification) -> TimeInterval {
        notification
            .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.doubleValue } ?? .zero
    }

    private func resolveKeyboardAnimationOptions(from notification: Notification) -> UIView.AnimationOptions {
        notification
            .userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.intValue }
            .map { UIView.AnimationOptions(rawValue: UInt($0) << 16) } ?? .curveLinear
    }

    private func handleKeyboardFrameNotification(_ notification: Notification) {
        let keyboardFrame = resolveKeyboardFrame(from: notification)

        guard self.keyboardFrame != keyboardFrame else {
            return
        }

        self.keyboardFrame = keyboardFrame

        handleKeyboardFrame(
            keyboardFrame,
            animationDuration: resolveKeyboardAnimationDuration(from: notification),
            animationOptions: resolveKeyboardAnimationOptions(from: notification)
        )
    }

    internal func subscribeToKeyboardNotifications() {
        keyboardWillShowNotificationObserver = NotificationObserver(
            name: UIResponder.keyboardWillShowNotification
        ) { [weak self] notification in
            self?.handleKeyboardFrameNotification(notification)
        }

        keyboardDidShowNotificationObserver = NotificationObserver(
            name: UIResponder.keyboardDidShowNotification
        ) { [weak self] notification in
            self?.handleKeyboardFrameNotification(notification)
        }

        keyboardWillChangeFrameNotificationObserver = NotificationObserver(
            name: UIResponder.keyboardWillChangeFrameNotification
        ) { [weak self] notification in
            self?.handleKeyboardFrameNotification(notification)
        }

        keyboardDidChangeFrameNotificationObserver = NotificationObserver(
            name: UIResponder.keyboardDidChangeFrameNotification
        ) { [weak self] notification in
            self?.handleKeyboardFrameNotification(notification)
        }

        keyboardWillHideNotificationObserver = NotificationObserver(
            name: UIResponder.keyboardWillHideNotification
        ) { [weak self] notification in
            self?.handleKeyboardFrameNotification(notification)
        }

        keyboardDidHideNotificationObserver = NotificationObserver(
            name: UIResponder.keyboardDidHideNotification
        ) { [weak self] notification in
            self?.handleKeyboardFrameNotification(notification)
        }
    }

    internal func unsubscribeFromKeyboardNotifications() {
        keyboardWillShowNotificationObserver = nil
        keyboardDidShowNotificationObserver = nil

        keyboardWillChangeFrameNotificationObserver = nil
        keyboardDidChangeFrameNotificationObserver = nil

        keyboardWillHideNotificationObserver = nil
        keyboardDidHideNotificationObserver = nil
    }
}
#endif
