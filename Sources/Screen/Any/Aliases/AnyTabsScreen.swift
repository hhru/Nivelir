#if canImport(UIKit)
import UIKit

/// Alias for `AnyScreen` with tabs container.
///
/// - SeeAlso: `AnyScreen`
public typealias AnyTabsScreen = AnyScreen<UITabBarController>

extension AnyTabsScreen {

    /// Creates a type-erasing screen to wrap the provided screen.
    ///
    /// - Parameter wrapped: A screen to wrap with a type-eraser.
    @MainActor
    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container: UITabBarController {
        self.init(wrapped) { screen, navigator in
            screen.build(navigator: navigator)
        }
    }
}

extension Screen where Container: UITabBarController {

    /// Wraps this screen with a type eraser.
    ///
    /// Use `eraseToAnyTabsScreen()` to expose an instance of `AnyTabsScreen`, rather than this screen’s actual type.
    /// This form of type erasure preserves abstraction across API boundaries, such as different modules.
    /// When you expose your screens as the `AnyTabsScreen` type,
    /// you can change the underlying implementation over time without affecting existing clients.
    ///
    /// - Returns: An `AnyTabsScreen` wrapping this screen.
    ///
    /// - SeeAlso: `AnyTabsScreen`
    /// - SeeAlso: `AnyScreen`
    @MainActor
    public func eraseToAnyTabsScreen() -> AnyTabsScreen {
        AnyTabsScreen(self)
    }
}
#endif
