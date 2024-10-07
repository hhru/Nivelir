#if canImport(UIKit)
import UIKit

/// The style that will be applied to the appearance of the HUD.
public struct HUDStyle: Sendable {

    /// Default style.
    ///
    /// Default values:
    /// - ``cornerRadius`` = `10.0`
    /// - ``backgroundColor`` = `.systemGray`
    /// - ``dimmingColor`` =  `UIColor.black.withAlphaComponent(0.2)`
    public static let `default` = Self()

    /// Corner radius for progress view.
    public let cornerRadius: CGFloat

    /// Background color for progress view.
    public let backgroundColor: UIColor

    /// The color of the dimming background of HUD.
    public let dimmingColor: UIColor

    /// Creates new style.
    /// - Parameters:
    ///   - cornerRadius: Corner radius for progress view. Default is `10.0`.
    ///   - backgroundColor: Background color for progress view. Default is `.systemGray`.
    ///   - dimmingColor: The color of the dimming background of HUD.
    ///   Default is `UIColor.black.withAlphaComponent(0.2)`.
    public init(
        cornerRadius: CGFloat = 10.0,
        backgroundColor: UIColor = .systemGray,
        dimmingColor: UIColor = UIColor.black.withAlphaComponent(0.2)
    ) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.dimmingColor = dimmingColor
    }
}
#endif
