#if canImport(ObjectiveC)
import ObjectiveC

private let screenPayloadAssociation = ObjectAssociation<ScreenPayload>()

extension ScreenPayloadedContainer where Self: NSObject {

    public var screenPayload: ScreenPayload {
        if let payload = screenPayloadAssociation[self] {
            return payload
        }

        let payload = ScreenPayload()

        screenPayloadAssociation[self] = payload

        return payload
    }
}
#endif
