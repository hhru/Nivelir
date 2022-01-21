#if canImport(UIKit)
import UIKit

/// Makes the receiver the key window.
public struct ScreenMakeKeyAction<Container: UIWindow>: ScreenAction {

    public typealias Output = Void

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        container.makeKey()

        completion(.success)
    }
}

extension ScreenThenable where Current: UIWindow {

    /// Makes the receiver the key window.
    ///
    /// Usage examples
    /// ==============
    ///
    /// - Makes the window container of the current container the key window:
    ///
    /// ``` swift
    /// navigator.navigate(from: container) { route in
    ///     route
    ///         .window
    ///         .makeKey()
    /// }
    /// ```
    ///
    /// - Returns: An instance containing the new action.
    public func makeKey() -> Self {
        then(ScreenMakeKeyAction<Current>())
    }
}
#endif
