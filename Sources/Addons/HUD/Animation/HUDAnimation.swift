#if canImport(UIKit)
import UIKit

/// The animation type that should be used when the ``HUD`` is shown and hidden.
@MainActor
public enum HUDAnimation {

    /// Custom animation for showing and hiding the HUD.
    ///
    /// Implement ``HUDCustomAnimation`` to configure a custom animation and pass an instance to the associated value.
    case custom(HUDCustomAnimation)

    /// Animates the appearance for the specified `view`, using an animation type.
    /// - Parameters:
    ///   - view: The container view of HUD.
    ///   - completion: A closure to be called when the animation sequence ends.
    ///   This block has no return value.
    ///   This parameter may be `nil`.
    public func animateAppearance(
        of view: UIView,
        completion: (() -> Void)?
    ) {
        switch self {
        case let .custom(animation):
            animation.animateAppearance(
                of: view,
                completion: completion
            )
        }
    }

    /// Animates the update for the specified `view`, using an animation type.
    /// - Parameters:
    ///   - body: A closure containing the changes to update HUD style.
    ///   - view: The container view of HUD.
    ///   - completion: A closure to be called when the animation sequence ends.
    ///   This block has no return value.
    ///   This parameter may be `nil`.
    public func animateUpdate(
        body: @escaping () -> Void,
        of view: UIView,
        completion: (() -> Void)?
    ) {
        switch self {
        case let .custom(animation):
            animation.animateUpdate(
                body: body,
                of: view,
                completion: completion
            )
        }
    }

    /// Animates the disappearance for the specified `view`, using an animation type.
    /// - Parameters:
    ///   - view: The container view of HUD.
    ///   - completion: A closure to be called when the animation sequence ends.
    ///   This block has no return value.
    ///   This parameter may be `nil`.
    public func animateDisappearance(
        of view: UIView,
        completion: (() -> Void)?
    ) {
        switch self {
        case let .custom(animation):
            animation.animateDisappearance(
                of: view,
                completion: completion
            )
        }
    }
}
#endif
