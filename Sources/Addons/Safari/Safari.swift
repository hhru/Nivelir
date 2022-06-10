#if canImport(UIKit) && canImport(SafariServices)
import UIKit
import SafariServices

public struct Safari: CustomStringConvertible {

    private let anyConfiguration: Any?

    public let url: URL

    public let didInitialize: ((_ container: SFSafariViewController) -> Void)?
    public let didCompleteInitialLoad: ((_ successfully: Bool) -> Void)?
    public let didRedirectInitialLoad: ((_ url: URL) -> Void)?
    public let didFinish: (() -> Void)?
    public let willOpenInBrowser: (() -> Void)?

    @available(iOS 11.0, *)
    public var configuration: SFSafariViewController.Configuration? {
        anyConfiguration as? SFSafariViewController.Configuration
    }

    public var description: String {
        "Safari(\"\(url)\")"
    }

    public init(
        url: URL,
        didInitialize: ((_ container: SFSafariViewController) -> Void)? = nil,
        didCompleteInitialLoad: ((_ successfully: Bool) -> Void)? = nil,
        didRedirectInitialLoad: ((_ url: URL) -> Void)? = nil,
        didFinish: (() -> Void)? = nil,
        willOpenInBrowser: (() -> Void)? = nil
    ) {
        self.url = url
        self.anyConfiguration = nil

        self.didInitialize = didInitialize
        self.didCompleteInitialLoad = didCompleteInitialLoad
        self.didRedirectInitialLoad = didRedirectInitialLoad
        self.didFinish = didFinish
        self.willOpenInBrowser = willOpenInBrowser
    }

    @available(iOS 11.0, *)
    public init(
        url: URL,
        configuration: SFSafariViewController.Configuration,
        didInitialize: ((_ container: SFSafariViewController) -> Void)? = nil,
        didCompleteInitialLoad: ((_ successfully: Bool) -> Void)? = nil,
        didRedirectInitialLoad: ((_ url: URL) -> Void)? = nil,
        didFinish: (() -> Void)? = nil,
        willOpenInBrowser: (() -> Void)? = nil
    ) {
        self.url = url
        self.anyConfiguration = configuration

        self.didInitialize = didInitialize
        self.didCompleteInitialLoad = didCompleteInitialLoad
        self.didRedirectInitialLoad = didRedirectInitialLoad
        self.didFinish = didFinish
        self.willOpenInBrowser = willOpenInBrowser
    }
}
#endif
