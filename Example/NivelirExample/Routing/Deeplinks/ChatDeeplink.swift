import Foundation
import Nivelir

struct ChatDeeplink {

    let roomID: Int
    let chatID: Int

    func navigate(
        screens: Screens,
        navigator: ScreenNavigator,
        handler: DeeplinkHandler
    ) throws {
        navigator.navigate(
            to: screens.showChatRoute(
                roomID: roomID,
                chatID: chatID
            )
        )
    }
}

extension ChatDeeplink: NotificationDeeplink {

    static func notification(userInfo: ChatDeeplinkPayload, context: Services) throws -> Self? {
        Self(roomID: userInfo.roomID, chatID: userInfo.chatID)
    }
}

extension ChatDeeplink: URLDeeplink {

    static func url(
        scheme: String,
        host: String,
        path: [String],
        query: ChatDeeplinkPayload?,
        context: Services
    ) throws -> ChatDeeplink? {
        guard let payload = query, scheme == "nivelir", host == "chat" else {
            return nil
        }

        return Self(roomID: payload.roomID, chatID: payload.chatID)
    }
}

#if os(iOS)
extension ChatDeeplink: ShortcutDeeplink {

    static func shortcut(
        type: String,
        userInfo: ChatDeeplinkPayload?,
        context: Services
    ) throws -> ChatDeeplink? {
        guard let payload = userInfo else {
            return nil
        }

        switch type {
        case "FirstChatInFirstRoom",
             "SecondChatInFirstRoom",
             "SecondChatInSecondRoom":
            return Self(roomID: payload.roomID, chatID: payload.chatID)

        default:
            return nil
        }
    }
}
#endif
