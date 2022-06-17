#if canImport(UIKit) && os(iOS)
import UIKit

public protocol SharingVisualActivity: SharingCustomActivity {

    func prepare(
        for items: [SharingItem],
        completion: @escaping (_ completed: Bool) -> Void
    ) -> AnyModalScreen
}
#endif
