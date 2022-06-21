#if canImport(UIKit)
import UIKit

public struct HUDStyle {

    public static let `default` = Self()

    public let cornerRadius: CGFloat
    public let backgroundColor: UIColor
    public let dimmingColor: UIColor

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
