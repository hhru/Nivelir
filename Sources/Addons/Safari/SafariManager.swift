#if canImport(SafariServices) && os(iOS)
import Foundation
import SafariServices

@MainActor
internal final class SafariManager:
    NSObject,
    SFSafariViewControllerDelegate {

    private let safari: Safari
    private let navigator: ScreenNavigator

    internal init(
        safari: Safari,
        navigator: ScreenNavigator
    ) {
        self.safari = safari
        self.navigator = navigator
    }

    internal func safariViewController(
        _ controller: SFSafariViewController,
        didCompleteInitialLoad successfully: Bool
    ) {
        safari.didCompleteInitialLoad?(successfully)
    }

    internal func safariViewController(
        _ controller: SFSafariViewController,
        initialLoadDidRedirectTo url: URL
    ) {
        safari.didRedirectInitialLoad?(url)
    }

    internal func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        safari.didFinish?()
    }

    internal func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
        safari.willOpenInBrowser?()
    }

    internal func safariViewController(
        _ controller: SFSafariViewController,
        activityItemsFor url: URL,
        title: String?
    ) -> [UIActivity] {
        safari
            .sharingApplicationActivities?(url, title)
            .map { $0.activity(navigator: navigator) } ?? []
    }

    internal func safariViewController(
        _ controller: SFSafariViewController,
        excludedActivityTypesFor url: URL,
        title: String?
    ) -> [UIActivity.ActivityType] {
        safari.sharingExcludedActivityTypes?(url, title) ?? []
    }
}
#endif
