#if canImport(UIKit)
import UIKit

public protocol ScreenPayloadAssociating {
    associatedtype Container: UIViewController

    func build(navigator: ScreenNavigator) -> Container
}

extension Screen where Self: ScreenPayloadAssociating {

    public func build(
        navigator: ScreenNavigator,
        payload: Any?
    ) -> Container {
        build(navigator: navigator).associating(with: payload)
    }
}

private var screenPayloadAssociationKey: UInt8 = 0

extension UIViewController {

    internal func associating(with screenPayload: Any?) -> Self {
        objc_setAssociatedObject(
            self,
            &screenPayloadAssociationKey,
            screenPayload,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )

        return self
    }
}
#endif
