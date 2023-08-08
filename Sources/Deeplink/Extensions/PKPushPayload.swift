#if canImport(PushKit) && os(iOS)
import Foundation
import PushKit

extension PKPushPayload {

    internal var logDescription: String? {
        let dictionaryPayload = self.dictionaryPayload

        let jsonData = try? JSONSerialization.data(
            withJSONObject: dictionaryPayload,
            options: .prettyPrinted
        )

        return jsonData.flatMap { jsonData in
            String(data: jsonData, encoding: .utf8)
        }
    }
}
#endif
