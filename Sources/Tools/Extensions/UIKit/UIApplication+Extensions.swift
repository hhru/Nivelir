#if canImport(UIKit)
import UIKit

extension UIApplication {

    internal var firstKeyWindow: UIWindow? {
        if #available(iOS 13, tvOS 13.0, *) {
            return connectedScenes
                .lazy
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return keyWindow
        }
    }
}
#endif
