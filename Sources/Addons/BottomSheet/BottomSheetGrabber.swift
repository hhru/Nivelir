#if canImport(UIKit)
import UIKit

public struct BottomSheetGrabber: Equatable, Sendable {

    public static let `default` = Self()

    public let size: CGSize
    public let color: UIColor
    public let inset: CGFloat

    public init(
        size: CGSize = CGSize(width: 36.0, height: 5.0),
        color: UIColor = UIColor.darkGray.withAlphaComponent(0.4),
        inset: CGFloat = 5.0
    ) {
        self.size = size
        self.color = color
        self.inset = inset
    }
}
#endif
