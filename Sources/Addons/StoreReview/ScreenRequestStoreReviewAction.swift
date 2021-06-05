#if canImport(UIKit) && canImport(StoreKit) && os(iOS)
import UIKit
import StoreKit

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
extension ScreenThenable where Then: ScreenVisibleContainer {

    public func requestStoreReview() -> Self {
        then(ScreenRequestStoreReviewAction())
    }
}
#endif
