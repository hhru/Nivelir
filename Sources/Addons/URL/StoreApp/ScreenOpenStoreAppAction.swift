#if canImport(UIKit)
import UIKit

public struct ScreenOpenStoreAppAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public let appID: String
    public let forReview: Bool

    public init(appID: String, forReview: Bool = false) {
        self.appID = appID
        self.forReview = forReview
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        let rawURL = forReview
            ? "https://itunes.apple.com/app/id\(appID)?action=write-review"
            : "https://itunes.apple.com/app/id\(appID)"

        guard let url = URL(string: rawURL) else {
            return completion(.invalidStoreAppID(for: self))
        }

        ScreenOpenURLAction(url: url).perform(
            container: container,
            navigator: navigator,
            completion: completion
        )
    }
}

extension ScreenRoute {

    public func openStoreApp(id: String, forReview: Bool = false) -> Self {
        then(
            ScreenOpenStoreAppAction(
                appID: id,
                forReview: forReview
            )
        )
    }
}
#endif
