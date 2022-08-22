#if canImport(UIKit)
import UIKit

/// Attempts to asynchronously open the resource at the specified URL.
public struct ScreenOpenURLAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public let url: URL
    public let fallbackURLs: [URL]
    public let options: [UIApplication.OpenExternalURLOptionsKey: Any]

    public init(
        url: URL,
        fallbackURLs: [URL] = [],
        options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:]
    ) {
        self.url = url
        self.fallbackURLs = fallbackURLs
        self.options = options
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        let urls = fallbackURLs.prepending(url)

        guard let url = urls.first(where: { UIApplication.shared.canOpenURL($0) }) else {
            return completion(.failedToOpenURL(url, for: self))
        }

        UIApplication.shared.open(url, options: options) { success in
            completion(success ? .success : .failedToOpenURL(url, for: self))
        }
    }
}

extension ScreenThenable {

    /// Attempts to asynchronously open the resource at the specified URL.
    ///
    /// Use this action to open the specified resource.
    /// If the specified URL scheme is handled by another app, iOS launches that app and passes the URL to it.
    /// (Launching the app brings the other app to the foreground.)
    /// If no app is capable of handling the specified scheme, the action will complete with ``FailedToOpenURLError``.
    /// - Parameters:
    ///   - url: A URL.
    ///   The resource identified by this URL may be local to the current app
    ///   or it may be one that must be provided by a different app.
    ///   UIKit supports many common schemes, including the http, https, tel, facetime, and mailto schemes.
    ///   You can also employ custom URL schemes associated with apps installed on the device.
    ///   - fallbackURLs: Fallback URLs to open, in case of an error.
    ///   Action check `url` from parameters and all fallback URLs using method `canOpenURL(_:)`,
    ///   and will open the one with `true` value.
    ///   - options: A dictionary of options to use when opening the URL.
    ///   For a list of possible keys to include in this dictionary, see `UIApplication.OpenExternalURLOptionsKey`.
    /// - Returns: An instance containing the new action.
    public func openURL(
        _ url: URL,
        fallbackURLs: [URL] = [],
        options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:]
    ) -> Self {
        then(
            ScreenOpenURLAction(
                url: url,
                fallbackURLs: fallbackURLs,
                options: options
            )
        )
    }
}
#endif
