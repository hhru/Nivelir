#if canImport(UIKit) && os(iOS)
import UIKit

@MainActor
public protocol SharingSilentActivity: SharingCustomActivity {

    func perform(
        for items: [SharingItem],
        navigator: ScreenNavigator,
        completion: @escaping (_ completed: Bool) -> Void
    )
}
#endif
