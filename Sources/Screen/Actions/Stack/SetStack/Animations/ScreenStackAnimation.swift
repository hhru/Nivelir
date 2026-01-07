#if canImport(UIKit)
import UIKit

@MainActor
@frozen
public enum ScreenStackAnimation {

    case `default`
    case custom(ScreenStackCustomAnimation)

    public var isDefault: Bool {
        switch self {
        case .default:
            return true

        case .custom:
            return false
        }
    }

    public func animate(
        container: UINavigationController,
        stack: [UIViewController],
        completion: @escaping () -> Void
    ) {
        switch self {
        case .default:
            guard let transitionCoordinator = container.transitionCoordinator else {
                return DispatchQueue.main.async { completion() }
            }

            transitionCoordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }

        case let .custom(animation):
            animation.animate(
                container: container,
                stack: stack,
                completion: completion
            )
        }
    }
}

extension ScreenStackAnimation: Equatable {

    nonisolated public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.default, .default):
            return true

        case let (.custom(lhs), .custom(rhs)):
            return lhs.isEqual(to: rhs)

        case (_, _):
            return false
        }
    }
}
#endif
