#if canImport(UIKit)
import UIKit

/// Dismisses the screen container that was presented modally by the container
/// in which the action is performed.
///
/// - Note: Unlike the `dismiss(animated:completion:)` method of `UIViewController`,
///         this action dismisses only the presented container.
public struct ScreenDismissAction<Container: UIViewController>: ScreenAction {

    /// The type of value returned by the action.
    public typealias Output = Void

    /// A Boolean value indicating whether the transition will be animated.
    public let animated: Bool

    /// Creates action.
    ///
    /// - Parameter animated: A Boolean value indicating whether the transition will be animated.
    ///                       The default value is `true`.
    public init(animated: Bool = true) {
        self.animated = animated
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Dismissing screen presented by \(type(of: container))")

        guard container.presented != nil else {
            return completion(.success)
        }

        container.dismiss(animated: animated) {
            completion(.success)
        }
    }
}

extension ScreenThenable where Current: UIViewController {

    /// Dismisses the screen container that was presented modally by the container
    /// in which the action is performed.
    ///
    /// - Note: Unlike the `dismiss(animated:completion:)` method of `UIViewController`,
    ///         this action dismisses only the presented container.
    ///
    /// Usage examples
    /// ==============
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { $0.dismiss() }
    /// ```
    ///
    /// - Parameter animated: Pass `true` to animate the transition or `false`
    ///                       if you do not want the transition to be animated.
    ///                       The default value is `true`.
    /// - Returns: An instance containing the new action.
    public func dismiss(animated: Bool = true) -> Self {
        then(ScreenDismissAction<Current>(animated: animated))
    }
}
#endif
