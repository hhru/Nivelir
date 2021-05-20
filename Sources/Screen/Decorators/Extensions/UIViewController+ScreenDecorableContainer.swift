#if canImport(UIKit)
import UIKit

private var screenPayloadAssociatedKey: UInt8 = 0

extension UIViewController: ScreenDecorableContainer {

    public var screenPayload: Any? {
        get {
            objc_getAssociatedObject(
                self,
                &screenPayloadAssociatedKey
            )
        }

        set {
            objc_setAssociatedObject(
                self,
                &screenPayloadAssociatedKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
#endif
