import Foundation

struct ChatDeeplinkPayload: Decodable {

    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case chatID = "chat_id"
    }

    let roomID: Int
    let chatID: Int
}
