#if canImport(UIKit) && os(iOS)
import UIKit

@MainActor
internal protocol KeyboardHandler: AnyObject, Sendable {

    var keyboardFrame: CGRect { get }

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
        if let keyboardFrame = keyboardFrameAssociation[self] {
            return keyboardFrame
        }

        let screenBounds = UIScreen.main.bounds

        return CGRect(
            x: screenBounds.minX,
            y: screenBounds.maxY,
            width: screenBounds.width,
            height: .zero
        )
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

    private nonisolated func handleKeyboardFrameNotification(_ notification: Notification) {
        let keyboardFrame = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            .flatMap { $0 as? NSValue }
            .map { $0.cgRectValue } ?? .zero

        let animationDuration = notification
            .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.doubleValue } ?? .zero

        let animationOptions = notification
            .userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.intValue }
            .map { UIView.AnimationOptions(rawValue: UInt($0) << 16) } ?? .curveLinear

        MainActor.assumeIsolated {
            guard keyboardFrameAssociation[self] != keyboardFrame else {
                return
            }

            keyboardFrameAssociation[self] = keyboardFrame

            handleKeyboardFrame(
                keyboardFrame,
                animationDuration: animationDuration,
                animationOptions: animationOptions
            )
        }
    }
}

extension KeyboardHandler {

    internal func keyboardHeight(in view: UIView) -> CGFloat {
        let windowFrame = view.window.map { window in
            window.convert(window.bounds, to: nil)
        } ?? UIScreen.main.bounds

        let keyboardFrame = keyboardFrame

        guard windowFrame.intersects(keyboardFrame) else {
            return .zero
        }

        let isKeyboardFloating = abs(keyboardFrame.width - windowFrame.width) > 2.0
            || abs(keyboardFrame.maxX - windowFrame.maxX) > 2.0
            || abs(keyboardFrame.maxY - windowFrame.maxY) > 2.0

        guard !isKeyboardFloating else {
            return .zero
        }

        let viewFrame = view.convert(view.bounds, to: nil)

        guard windowFrame.intersects(viewFrame) else {
            return .zero
        }

        guard viewFrame.intersects(keyboardFrame) else {
            return .zero
        }

        let viewVisibleFrame = windowFrame.intersection(viewFrame)
        let keyboardVisibleFrame = windowFrame.intersection(keyboardFrame)

        let keyboardHeight = viewVisibleFrame.maxY - keyboardVisibleFrame.minY

        return min(max(keyboardHeight, .zero), keyboardVisibleFrame.height)
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
