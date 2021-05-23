#if canImport(UIKit)
import UIKit

private var screenPayloadAssociatedKey: UInt8 = 0

extension UIViewController: ScreenPayloadContainer {

    public var screenPayload: ScreenPayload {
        let payload = objc_getAssociatedObject(
            self,
            &screenPayloadAssociatedKey
        )

        if let payload = payload as? ScreenPayload {
            return payload
        }

        let newPayload = ScreenPayload()

        objc_setAssociatedObject(
            self,
            &screenPayloadAssociatedKey,
            newPayload,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )

        return newPayload
    }
}
#endif
