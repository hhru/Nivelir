import Foundation

internal final class DeeplinkStorage {

    internal let value: AnyDeeplink
    internal let scope: DeeplinkScope

    internal init(
        value: AnyDeeplink,
        scope: DeeplinkScope
    ) {
        self.value = value
        self.scope = scope
    }
}
