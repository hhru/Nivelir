#if canImport(UIKit) && canImport(SafariServices) && os(iOS)
import UIKit
import SafariServices

public struct Safari: CustomStringConvertible {

    private let storedConfiguration: Any?
    private let storedDismissButtonStyle: Any?

    public let url: URL

    public let preferredBarTintColor: UIColor?
    public let preferredControlTintColor: UIColor?

    public let didInitialize: ((_ container: SFSafariViewController) -> Void)?
    public let didCompleteInitialLoad: ((_ successfully: Bool) -> Void)?
    public let didRedirectInitialLoad: ((_ url: URL) -> Void)?
    public let didFinish: (() -> Void)?
    public let willOpenInBrowser: (() -> Void)?

    public let sharingApplicationActivities: ((_ url: URL, _ title: String?) -> [SharingActivity])?
    public let sharingExcludedActivityTypes: ((_ url: URL, _ title: String?) -> [SharingActivityType])?

    @available(iOS 11.0, *)
    public var configuration: SFSafariViewController.Configuration {
        storedConfiguration.flatMap { configuration in
            configuration as? SFSafariViewController.Configuration
        } ?? SFSafariViewController.Configuration()
    }

    @available(iOS 11.0, *)
    public var dismissButtonStyle: SFSafariViewController.DismissButtonStyle {
        storedDismissButtonStyle.flatMap { dismissButtonStyle in
            dismissButtonStyle as? SFSafariViewController.DismissButtonStyle
        } ?? .done
    }

    public var description: String {
        "Safari(\"\(url)\")"
    }

    public init(
        url: URL,
        preferredBarTintColor: UIColor? = nil,
        preferredControlTintColor: UIColor? = nil,
        didInitialize: ((_ container: SFSafariViewController) -> Void)? = nil,
        didCompleteInitialLoad: ((_ successfully: Bool) -> Void)? = nil,
        didRedirectInitialLoad: ((_ url: URL) -> Void)? = nil,
        didFinish: (() -> Void)? = nil,
        willOpenInBrowser: (() -> Void)? = nil,
        sharingApplicationActivities: ((_ url: URL, _ title: String?) -> [SharingActivity])? = nil,
        sharingExcludedActivityTypes: ((_ url: URL, _ title: String?) -> [SharingActivityType])? = nil
    ) {
        self.url = url

        self.storedConfiguration = nil
        self.storedDismissButtonStyle = nil

        self.preferredBarTintColor = preferredBarTintColor
        self.preferredControlTintColor = preferredControlTintColor

        self.didInitialize = didInitialize
        self.didCompleteInitialLoad = didCompleteInitialLoad
        self.didRedirectInitialLoad = didRedirectInitialLoad
        self.didFinish = didFinish
        self.willOpenInBrowser = willOpenInBrowser

        self.sharingApplicationActivities = sharingApplicationActivities
        self.sharingExcludedActivityTypes = sharingExcludedActivityTypes
    }

    @available(iOS 11.0, *)
    public init(
        url: URL,
        configuration: SFSafariViewController.Configuration,
        dismissButtonStyle: SFSafariViewController.DismissButtonStyle = .done,
        preferredBarTintColor: UIColor? = nil,
        preferredControlTintColor: UIColor? = nil,
        didInitialize: ((_ container: SFSafariViewController) -> Void)? = nil,
        didCompleteInitialLoad: ((_ successfully: Bool) -> Void)? = nil,
        didRedirectInitialLoad: ((_ url: URL) -> Void)? = nil,
        didFinish: (() -> Void)? = nil,
        willOpenInBrowser: (() -> Void)? = nil,
        sharingApplicationActivities: ((_ url: URL, _ title: String?) -> [SharingActivity])? = nil,
        sharingExcludedActivityTypes: ((_ url: URL, _ title: String?) -> [SharingActivityType])? = nil
    ) {
        self.url = url

        self.storedConfiguration = configuration
        self.storedDismissButtonStyle = dismissButtonStyle

        self.preferredBarTintColor = preferredBarTintColor
        self.preferredControlTintColor = preferredControlTintColor

        self.didInitialize = didInitialize
        self.didCompleteInitialLoad = didCompleteInitialLoad
        self.didRedirectInitialLoad = didRedirectInitialLoad
        self.didFinish = didFinish
        self.willOpenInBrowser = willOpenInBrowser

        self.sharingApplicationActivities = sharingApplicationActivities
        self.sharingExcludedActivityTypes = sharingExcludedActivityTypes
    }
}
#endif
