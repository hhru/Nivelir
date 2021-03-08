import UIKit

public protocol ScreenStackCustomAnimation {
    func isEqual(to other: ScreenStackCustomAnimation) -> Bool

    func animate(
        container: UINavigationController,
        stack: [UIViewController],
        completion: @escaping () -> Void
    )
}

extension ScreenStackCustomAnimation where Self: Equatable {

    public func isEqual(to other: ScreenStackCustomAnimation) -> Bool {
        guard let other = other as? Self else {
            return false
        }

        return self == other
    }
}
