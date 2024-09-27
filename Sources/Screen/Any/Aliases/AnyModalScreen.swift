#if canImport(UIKit)
import UIKit

/// Alias for `AnyScreen` with modal container.
///
/// - SeeAlso: `AnyScreen`
public typealias AnyModalScreen = AnyScreen<UIViewController>

extension AnyModalScreen {

    /// Creates a type-erasing screen to wrap the provided screen.
    ///
    /// - Parameter wrapped: A screen to wrap with a type-eraser.
    @MainActor
    public init<Wrapped: Screen>(
        _ wrapped: Wrapped
    ) where Wrapped.Container: UIViewController {
        self.init(wrapped) { screen, navigator in
            screen.build(navigator: navigator)
        }
    }
}

extension Screen where Container: UIViewController {

    /// Wraps this screen with a type eraser.
    ///
    /// Use `eraseToAnyModalScreen()` to expose an instance of `AnyModalScreen`, rather than this screen’s actual type.
    /// This form of type erasure preserves abstraction across API boundaries, such as different modules.
    /// When you expose your screens as the `AnyModalScreen` type,
    /// you can change the underlying implementation over time without affecting existing clients.
    ///
    /// - Returns: An `AnyModalScreen` wrapping this screen.
    ///
    /// - SeeAlso: `AnyModalScreen`
    /// - SeeAlso: `AnyScreen`
    @MainActor
    public func eraseToAnyModalScreen() -> AnyModalScreen {
        AnyModalScreen(self)
    }
}
#endif
