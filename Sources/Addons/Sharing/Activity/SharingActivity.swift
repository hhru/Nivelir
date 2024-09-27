#if canImport(UIKit) && os(iOS)
import UIKit

public struct SharingActivity {

    private typealias Body = @MainActor (_ navigator: ScreenNavigator) -> UIActivity

    private let body: Body

    private init(body: @escaping Body) {
        self.body = body
    }

    @MainActor
    internal func activity(navigator: ScreenNavigator) -> UIActivity {
        body(navigator)
    }
}

extension SharingActivity {

    public static func regular(_ value: UIActivity) -> Self {
        Self { _ in
            value
        }
    }

    public static func custom<Value: SharingVisualActivity>(_ value: Value) -> Self {
        Self { navigator in
            SharingActivityManager(
                navigator: navigator,
                activity: value
            )
        }
    }

    public static func custom<Value: SharingSilentActivity>(_ value: Value) -> Self {
        Self { navigator in
            SharingActivityManager(
                navigator: navigator,
                activity: value
            )
        }
    }
}
#endif
