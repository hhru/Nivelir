#if canImport(UIKit)
import UIKit

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
            return completion(.failedToOpenURL(for: self))
        }

        UIApplication.shared.open(url, options: options) { success in
            completion(success ? .success : .failedToOpenURL(for: self))
        }
    }
}

extension ScreenThenable {

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
