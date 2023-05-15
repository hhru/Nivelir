#if canImport(UIKit)
import UIKit

public struct BottomSheetAnimationOptions: Equatable {

    public static let transition = Self()
    public static let changes = Self(duration: 0.3)

    public let duration: TimeInterval
    public let curve: UIView.AnimationCurve

    public init(
        duration: TimeInterval = 0.4,
        curve: UIView.AnimationCurve = .easeInOut
    ) {
        self.duration = duration
        self.curve = curve
    }
}
#endif
