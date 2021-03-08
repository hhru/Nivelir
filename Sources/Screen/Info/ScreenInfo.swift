import Foundation

public struct ScreenInfo {

    public let key: ScreenKey
    public let payload: Any?

    public init(key: ScreenKey, payload: Any?) {
        self.key = key
        self.payload = payload
    }
}
