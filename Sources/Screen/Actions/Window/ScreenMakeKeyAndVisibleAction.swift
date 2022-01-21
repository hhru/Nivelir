#if canImport(UIKit)
import UIKit

/// Shows the window container and makes it the key window.
public struct ScreenMakeKeyAndVisibleAction<Container: UIWindow>: ScreenAction {

    public typealias Output = Void

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        container.makeKeyAndVisible()

        completion(.success)
    }
}

extension ScreenThenable where Current: UIWindow {

    /// Shows the window container and makes it the key window.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Shows the window container of the current container and makes it the key window:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .window
    ///         .makeKeyAndVisible()
    /// }
    /// ```
    ///
    /// - Returns: An instance containing the new action.
    public func makeKeyAndVisible() -> Self {
        then(ScreenMakeKeyAndVisibleAction<Current>())
    }
}
#endif
