import Foundation

public protocol ScreenVisibleContainer: ScreenContainer {
    var isVisible: Bool { get }

    @available(iOS 13.0, tvOS 13.0, *)
    var windowScene: UIWindowScene? { get }
}
