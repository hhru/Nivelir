#if canImport(UIKit)
import UIKit

public struct BottomSheetShadow: Equatable {

    public static let `default` = Self()

    public let offset: CGSize
    public let radius: CGFloat
    public let color: UIColor?
    public let opacity: Float
    public let shouldRasterize: Bool

    public init(
        offset: CGSize = CGSize(width: .zero, height: -3),
        radius: CGFloat = 3.0,
        color: UIColor? = .black,
        opacity: Float = .zero,
        shouldRasterize: Bool = false
    ) {
        self.offset = offset
        self.radius = radius
        self.color = color
        self.opacity = opacity
        self.shouldRasterize = shouldRasterize
    }
}
#endif
