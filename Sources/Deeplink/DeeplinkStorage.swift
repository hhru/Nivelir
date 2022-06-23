import Foundation

internal final class DeeplinkStorage {

    internal let value: AnyDeeplink
    internal let type: DeeplinkType
    internal let scope: DeeplinkScope

    internal init(
        value: AnyDeeplink,
        type: DeeplinkType,
        scope: DeeplinkScope
    ) {
        self.value = value
        self.type = type
        self.scope = scope
    }
}
