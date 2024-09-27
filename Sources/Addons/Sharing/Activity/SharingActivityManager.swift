#if canImport(UIKit) && os(iOS)
import UIKit

@MainActor
internal final class SharingActivityManager<Activity: SharingCustomActivity>: UIActivity {

    internal override class var activityCategory: UIActivity.Category {
        Activity.category
    }

    private var items: [SharingItem] = []

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
        guard let activity = activity as? SharingVisualActivity else {
            return nil
        }

        let screen = activity.prepare(for: items) { [weak self] completed in
            self?.activityDidFinish(completed)
        }

        return MainActor.assumeIsolated { [navigator] in
            screen.build(navigator: navigator)
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
        activity.isApplicable(for: activityItems.map(SharingItem.init(activityItem:)))
    }

    internal override func prepare(withActivityItems activityItems: [Any]) {
        items = activityItems.map(SharingItem.init(activityItem:))
    }

    internal override func perform() {
        guard let activity = activity as? SharingSilentActivity else {
            return activityDidFinish(false)
        }

        activity.perform(for: items, navigator: navigator) { [weak self] completed in
            self?.activityDidFinish(completed)
        }
    }
}
#endif
