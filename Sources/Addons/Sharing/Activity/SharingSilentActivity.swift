#if canImport(UIKit) && os(iOS)
import UIKit

public protocol SharingSilentActivity: SharingCustomActivity, Sendable {

    @MainActor
    func perform(
        for items: [SharingItem],
        navigator: ScreenNavigator,
        completion: @escaping (_ completed: Bool) -> Void
    )
}
#endif
