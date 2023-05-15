#if canImport(UIKit)
import UIKit

public struct BottomSheetBorder: Equatable {

    public static let `default` = Self()

    public let width: CGFloat
    public let color: UIColor?

    public init(
        width: CGFloat = .zero,
        color: UIColor = .black
    ) {
        self.width = width
        self.color = color
    }
}
#endif
