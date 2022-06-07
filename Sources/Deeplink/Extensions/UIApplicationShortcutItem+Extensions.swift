#if canImport(UIKit) && os(iOS)
import UIKit

extension UIApplicationShortcutItem {

    internal var logDescription: String? {
        let description: [String: Any?] = [
            "type": type,
            "title": localizedTitle,
            "userInfo": userInfo
        ]

        let jsonData = try? JSONSerialization.data(
            withJSONObject: description,
            options: .prettyPrinted
        )

        return jsonData.flatMap { jsonData in
            String(data: jsonData, encoding: .utf8)
        }
    }
}
#endif
