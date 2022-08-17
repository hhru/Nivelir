#if canImport(UIKit)
import UIKit

/// Action, to open the page of the application in the App Store.
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

extension ScreenThenable {

    /// Opens the page with the application in the App Store.
    ///
    /// The action will open the App Store application
    /// with the page of the application whose `id` is specified in the parameter.
    /// - Parameters:
    ///   - id: Application ID.
    ///   An iOS application’s store ID number can be found
    ///   in the App Store URL as the string of numbers directly after `id`.
    ///   For Example, in `https://apps.apple.com/ru/app/работа-и-вакансии-на-hh/id502838820` the ID is: 502838820.
    ///   - forReview: Pass `true` if you want to open a page to write a review of the app.
    /// - Returns: An instance containing the new action.
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
