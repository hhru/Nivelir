#if canImport(UIKit) && canImport(StoreKit) && os(iOS)
import UIKit
import StoreKit

/// Tells StoreKit to ask the user to rate or review your app, if appropriate.
@available(iOS 10.3, *)
public struct ScreenRequestStoreReviewAction<Container: ScreenVisibleContainer>: ScreenAction {

    public typealias Output = Void

    public init() { }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Requesting app review on \(type(of: container))")

        if #available(iOS 14.0, *) {
            guard let windowScene = container.windowScene else {
                return completion(.containerNotFound(type: UIWindowScene.self, for: self))
            }

            SKStoreReviewController.requestReview(in: windowScene)
        } else {
            SKStoreReviewController.requestReview()
        }

        DispatchQueue.main.async {
            completion(.success)
        }
    }
}

@available(iOS 10.3, *)
extension ScreenThenable where Current: ScreenVisibleContainer {

    /// Tells StoreKit to ask the user to rate or review the app, if appropriate.
    ///
    /// For iOS 14 and above, this action using the scene of container.
    ///
    /// Although you normally call this method when it makes sense in the user experience flow of your app,
    /// App Store policy governs the actual display of a rating and review request view.
    /// Because this method may not present an alert,
    /// it isn’t appropriate to call ``requestStoreReview()`` in response to a button tap or other user action.
    ///
    /// - Note: When you call this method while your app is in development mode,
    /// a rating and review request view is always displayed so you can test the user interface and experience.
    /// However, this method has no effect when you call it in an app that you distribute using TestFlight.
    ///
    /// When you call this method in your shipping app and the system displays a rating and review request view,
    /// the system handles the entire process for you.
    /// In addition, you can continue to include a persistent link
    /// in the settings or configuration screens of your app that links to your App Store product page.
    /// To automatically open a page on which users can write a review in the App Store,
    ///  append the query parameter `action=write-review` to your product URL.
    /// - Returns: An instance containing the new action.
    public func requestStoreReview() -> Self {
        then(ScreenRequestStoreReviewAction())
    }
}
#endif
