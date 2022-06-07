#if canImport(UserNotifications) && os(iOS)
import Foundation
import UserNotifications

extension UNNotificationResponse {

    internal var logDescription: String? {
        let userInfo = notification.request.content.userInfo

        let jsonData = try? JSONSerialization.data(
            withJSONObject: userInfo,
            options: .prettyPrinted
        )

        return jsonData.flatMap { jsonData in
            String(data: jsonData, encoding: .utf8)
        }
    }
}
#endif
