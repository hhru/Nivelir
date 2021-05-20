#if canImport(UIKit)
import UIKit

public struct ScreenKeyWindowProvider: ScreenWindowProvider {

    public let application: UIApplication

    public var window: UIWindow? {
        if #available(iOS 13, *) {
            return application.windows.first { $0.isKeyWindow }
        } else {
            return application.keyWindow
        }
    }

    public init(application: UIApplication = .shared) {
        self.application = application
    }
}
#endif
