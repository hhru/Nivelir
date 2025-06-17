#if canImport(UIKit) && os(iOS)
import UIKit

internal final class SharingActivityManager<Activity: SharingCustomActivity>: UIActivity, @unchecked Sendable {

    internal override class var activityCategory: UIActivity.Category {
        Activity.category
    }

    private let accessQueue = DispatchQueue(
        label: "SharingActivityManager \(UUID().uuidString)",
        qos: .userInitiated,
        attributes: .concurrent
    )

    private var unsafeItems: [SharingItem] = []

    private var items: [SharingItem] {
        get {
            accessQueue.sync { unsafeItems }
        }
        set {
            accessQueue.async(flags: .barrier) {
                self.unsafeItems = newValue
            }
        }
    }

    internal let navigator: ScreenNavigator
    internal let activity: Activity

    internal override var activityType: UIActivity.ActivityType? {
        activity.type
    }

    internal override var activityTitle: String? {
        activity.title
    }

    internal override var activityImage: UIImage? {
        activity.image
    }

    internal override var activityViewController: UIViewController? {
        MainActor.assumeIsolated {
            guard let activity = activity as? SharingVisualActivity else {
                return nil
            }

            let screen = activity.prepare(for: items) { [weak self] completed in
                self?.activityDidFinish(completed)
            }

            return screen.build(navigator: navigator)
        }
    }

    internal init(
        navigator: ScreenNavigator,
        activity: Activity
    ) {
        self.navigator = navigator
        self.activity = activity
    }

    internal override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        let activityItems = activityItems.map(SharingItem.init(activityItem:))

        return activity.isApplicable(for: activityItems)
    }

    internal override func prepare(withActivityItems activityItems: [Any]) {
        items = activityItems.map(SharingItem.init(activityItem:))
    }

    internal override func perform() {
        MainActor.assumeIsolated {
            guard let activity = activity as? SharingSilentActivity else {
                return activityDidFinish(false)
            }

            activity.perform(for: items, navigator: navigator) { [weak self] completed in
                self?.activityDidFinish(completed)
            }
        }
    }
}
#endif
