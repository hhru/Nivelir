#if canImport(UIKit)
import UIKit

extension UIApplication {

    internal var firstKeyWindow: UIWindow? {
        connectedScenes
            .lazy
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
#endif
