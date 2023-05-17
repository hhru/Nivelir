#if canImport(UIKit)
import UIKit

extension UIPanGestureRecognizer {

    internal func predictedLocation(
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

    internal func predictedTranslation(
        in view: UIView?,
        decelerationRate: UIScrollView.DecelerationRate
    ) -> CGPoint {
        let location = location(in: view)

        let predictedLocation = predictedLocation(
            in: view,
            decelerationRate: .fast
        )

        let translation = translation(in: view)

        return CGPoint(
            x: translation.x + predictedLocation.x - location.x,
            y: translation.y + predictedLocation.y - location.y
        )
    }
}
#endif
