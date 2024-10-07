#if canImport(UIKit)
import UIKit

/// A type describing the animation of showing, updating and hiding the ``HUD``.
///
/// See ``HUDDefaultAnimation`` for example.
@MainActor
public protocol HUDCustomAnimation {

    /// Animates the appearance for the specified `view`.
    /// - Parameters:
    ///   - view: The container view of HUD.
    ///   - completion: A closure to be called when the animation sequence ends.
    ///   This block has no return value.
    ///   This parameter may be `nil`.
    func animateAppearance(
        of view: UIView,
        completion: (() -> Void)?
    )

    /// Animates the update for the specified `view`.
    /// - Parameters:
    ///   - body: A closure containing the changes to update HUD style.
    ///   - view: The container view of HUD.
    ///   - completion: A closure to be called when the animation sequence ends.
    ///   This block has no return value.
    ///   This parameter may be `nil`.
    func animateUpdate(
        body: @escaping () -> Void,
        of view: UIView,
        completion: (() -> Void)?
    )

    /// Animates the disappearance for the specified `view`.
    /// - Parameters:
    ///   - view: The container view of HUD.
    ///   - completion: A closure to be called when the animation sequence ends.
    ///   This block has no return value.
    ///   This parameter may be `nil`.
    func animateDisappearance(
        of view: UIView,
        completion: (() -> Void)?
    )
}
#endif
