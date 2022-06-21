#if canImport(UIKit)
import UIKit

public struct HUD: CustomStringConvertible {

    public static func `default`(progress: Progress) -> Self {
        Self(progress: progress)
    }

    public let progress: Progress
    public let style: HUDStyle

    public var description: String {
        "HUD(\(progress))"
    }

    public init(
        progress: Progress,
        style: HUDStyle = .default
    ) {
        self.progress = progress
        self.style = style
    }
}

extension HUD {

    public static func show(
        _ hud: HUD,
        in window: UIWindow,
        animation: HUDAnimation? = .default,
        duration: TimeInterval? = nil,
        completion: (() -> Void)? = nil
    ) {
        HUDView.showHUD(
            hud,
            in: window,
            animation: animation,
            duration: duration,
            completion: completion
        )
    }

    public static func show(
        _ hud: HUD,
        animation: HUDAnimation? = .default,
        duration: TimeInterval? = nil,
        completion: (() -> Void)? = nil
    ) {
        HUDView.showHUD(
            hud,
            animation: animation,
            duration: duration,
            completion: completion
        )
    }

    public static func hide(
        in window: UIWindow,
        completion: (() -> Void)? = nil
    ) {
        HUDView.hideHUD(
            in: window,
            completion: completion
        )
    }

    public static func hide(completion: (() -> Void)? = nil) {
        HUDView.hideHUD(completion: completion)
    }
}
#endif
