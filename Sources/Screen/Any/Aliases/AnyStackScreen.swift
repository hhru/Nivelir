#if canImport(UIKit)
import UIKit

/// Alias for `AnyScreen` with stack container.
///
/// - SeeAlso: `AnyScreen`
public typealias AnyStackScreen = AnyScreen<UINavigationController>

extension AnyStackScreen {

    /// Creates a type-erasing screen to wrap the provided screen.
    ///
    /// - Parameter wrapped: A screen to wrap with a type-eraser.
    @MainActor
    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container: UINavigationController {
        self.init(wrapped) { screen, navigator in
            screen.build(navigator: navigator)
        }
    }
}

extension Screen where Container: UINavigationController {

    /// Wraps this screen with a type eraser.
    ///
    /// Use `eraseToAnyStackScreen()` to expose an instance of `AnyStackScreen`, rather than this screen’s actual type.
    /// This form of type erasure preserves abstraction across API boundaries, such as different modules.
    /// When you expose your screens as the `AnyStackScreen` type,
    /// you can change the underlying implementation over time without affecting existing clients.
    ///
    /// - Returns: An `AnyStackScreen` wrapping this screen.
    ///
    /// - SeeAlso: `AnyStackScreen`
    /// - SeeAlso: `AnyScreen`
    @MainActor
    public func eraseToAnyStackScreen() -> AnyStackScreen {
        AnyStackScreen(self)
    }
}
#endif
