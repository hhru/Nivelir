#if canImport(UIKit) && canImport(SafariServices) && os(iOS)
import UIKit
import SafariServices

/// An object for configuring the web browsing interface.
public struct Safari: CustomStringConvertible {

    private let storedConfiguration: Any?
    private let storedDismissButtonStyle: Any?

    /// The URL to navigate to. The URL must use the http or https scheme.
    public let url: URL

    /// The color to tint the background of the navigation bar and the toolbar.
    public let preferredBarTintColor: UIColor?

    /// The color to tint the control buttons on the navigation bar and the toolbar.
    public let preferredControlTintColor: UIColor?

    /// A closure that returns the created `SFSafariViewController` in the argument.
    public let didInitialize: ((_ container: SFSafariViewController) -> Void)?

    /// Called when the initial URL loading is complete.
    public let didCompleteInitialLoad: ((_ successfully: Bool) -> Void)?

    /// Called when the initial load is redirected to a new URL.
    public let didRedirectInitialLoad: ((_ url: URL) -> Void)?

    /// Called when the browser is redirected to another URL while loading the initial page.
    public let didFinish: (() -> Void)?

    /// Called when the user opens the current page in the default browser by tapping the toolbar button.
    public let willOpenInBrowser: (() -> Void)?

    /// Called when the user tapped an Action button.
    public let sharingApplicationActivities: ((_ url: URL, _ title: String?) -> [SharingActivity])?

    /// Allows you to exclude certain UIActivityTypes
    /// from the UIActivityViewController presented when the user taps the action button.
    public let sharingExcludedActivityTypes: ((_ url: URL, _ title: String?) -> [SharingActivityType])?

    /// The configuration for the `SFSafariViewController`.
    @available(iOS 11.0, *)
    public var configuration: SFSafariViewController.Configuration {
        storedConfiguration.flatMap { configuration in
            configuration as? SFSafariViewController.Configuration
        } ?? SFSafariViewController.Configuration()
    }

    @available(iOS 11.0, *)
    /// The style of dismiss button to use in the navigation bar to close SFSafariViewController.
    public var dismissButtonStyle: SFSafariViewController.DismissButtonStyle {
        storedDismissButtonStyle.flatMap { dismissButtonStyle in
            dismissButtonStyle as? SFSafariViewController.DismissButtonStyle
        } ?? .done
    }

    public var description: String {
        "Safari(\"\(url)\")"
    }

    /// Creates a configuration.
    /// - Parameters:
    ///   - url: The URL to navigate to. The URL must use the http or https scheme.
    ///   - preferredBarTintColor: The color to tint the background of the navigation bar and the toolbar.
    ///   - preferredControlTintColor: The color to tint the control buttons on the navigation bar and the toolbar.
    ///   - didInitialize: Closure to configure the `SFSafariViewController` after initialization.
    ///   - didCompleteInitialLoad: Called when the initial URL loading is complete.
    ///   - didRedirectInitialLoad: Called when the initial load is redirected to a new URL.
    ///   - didFinish: Called when the browser is redirected to another URL while loading the initial page.
    ///   - willOpenInBrowser: Called when the user opens the current page
    ///   in the default browser by tapping the toolbar button.
    ///   - sharingApplicationActivities: Called when the user tapped an Action button.
    ///   - sharingExcludedActivityTypes: Allows you to exclude certain UIActivityTypes
    ///   from the UIActivityViewController presented when the user taps the action button.
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

    /// Creates a configuration.
    /// - Parameters:
    ///   - url: The URL to navigate to. The URL must use the http or https scheme.
    ///   - configuration: The configuration for the `SFSafariViewController`.
    ///   - dismissButtonStyle: The style of dismiss button to use in
    ///   the navigation bar to close SFSafariViewController.
    ///   - preferredBarTintColor: The color to tint the background of the navigation bar and the toolbar.
    ///   - preferredControlTintColor: The color to tint the control buttons on the navigation bar and the toolbar.
    ///   - didInitialize: Closure to configure the `SFSafariViewController` after initialization.
    ///   - didCompleteInitialLoad: Called when the initial URL loading is complete.
    ///   - didRedirectInitialLoad: Called when the initial load is redirected to a new URL.
    ///   - didFinish: Called when the browser is redirected to another URL while loading the initial page.
    ///   - willOpenInBrowser: Called when the user opens the current page
    ///   in the default browser by tapping the toolbar button.
    ///   - sharingApplicationActivities: Called when the user tapped an Action button.
    ///   - sharingExcludedActivityTypes: Allows you to exclude certain UIActivityTypes
    ///   from the UIActivityViewController presented when the user taps the action button.
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
