#if canImport(UIKit)
import UIKit

extension UIPanGestureRecognizer {

    internal func projectedLocation(
        in view: UIView?,
        decelerationRate: UIScrollView.DecelerationRate
    ) -> CGPoint {
        guard decelerationRate.rawValue < 1.0 - .leastNonzeroMagnitude else {
            return location(in: view)
        }

        let location = location(in: view)
        let velocity = velocity(in: view)

        let deceleration = 0.001 / (1.0 - decelerationRate.rawValue)

        let offset = CGPoint(
            x: velocity.x * deceleration,
            y: velocity.y * deceleration
        )

        return CGPoint(
            x: location.x + offset.x,
            y: location.y + offset.y
        )
    }

    internal func projectedTranslation(
        in view: UIView?,
        decelerationRate: UIScrollView.DecelerationRate
    ) -> CGPoint {
        let location = location(in: view)

        let projectedLocation = projectedLocation(
            in: view,
            decelerationRate: .fast
        )

        let translation = translation(in: view)

        return CGPoint(
            x: translation.x + projectedLocation.x - location.x,
            y: translation.y + projectedLocation.y - location.y
        )
    }
}
#endif
