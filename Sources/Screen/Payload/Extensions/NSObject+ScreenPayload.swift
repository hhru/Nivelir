#if canImport(ObjectiveC)
import ObjectiveC

private var screenPayloadAssociatedKey: UInt8 = 0

extension NSObject {

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
