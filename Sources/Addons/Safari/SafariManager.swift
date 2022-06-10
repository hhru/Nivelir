#if canImport(SafariServices)
import Foundation
import SafariServices

internal final class SafariManager:
    NSObject,
    SFSafariViewControllerDelegate {

    private let safari: Safari

    internal init(safari: Safari) {
        self.safari = safari
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
}
#endif
