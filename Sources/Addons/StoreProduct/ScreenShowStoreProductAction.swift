#if canImport(UIKit) && canImport(StoreKit) && os(iOS)
import UIKit
import StoreKit

/// Action to show the `SKStoreProductViewController`.
public struct ScreenShowStoreProductAction<Container: UIViewController>: ScreenAction {

    public typealias Output = SKStoreProductViewController

    public let storeProduct: StoreProduct
    public let animated: Bool

    public init(
        storeProduct: StoreProduct,
        animated: Bool = true
    ) {
        self.storeProduct = storeProduct
        self.animated = animated
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        navigator.logInfo("Presenting \(storeProduct) on \(type(of: container))")

        guard let storeProductID = Int(storeProduct.itemID).map(NSNumber.init(value:)) else {
            return completion(.invalidStoreProductID(for: self))
        }

        let parameters = storeProduct
            .parameters
            .merging([SKStoreProductParameterITunesItemIdentifier: storeProductID]) { $1 }

        let storeProductContainer = SKStoreProductViewController()
        let storeProductManager = StoreProductManager(storeProduct: storeProduct)

        storeProduct.didInitialize?(storeProductContainer)

        storeProductContainer.screenPayload.store(storeProductManager)
        storeProductContainer.delegate = storeProductManager

        storeProductContainer.loadProduct(withParameters: parameters)

        container.present(storeProductContainer, animated: animated) {
            completion(.success(storeProductContainer))
        }
    }
}

extension ScreenThenable where Current: UIViewController {

    /// Present a view controller that provides a page where the user can purchase media from the App Store.
    /// - Parameters:
    ///   - storeProduct: An object for configuring the page.
    ///   - animated: Pass `true` to animate the presentation; otherwise, pass `false`.
    ///   - route: Nested route to be performed in the `SKStoreProductViewController`.
    /// - Returns: An instance containing the new action.
    public func showStoreProduct<Route: ScreenThenable>(
        _ storeProduct: StoreProduct,
        animated: Bool = true,
        route: Route
    ) -> Self where Route.Root == SKStoreProductViewController {
        fold(
            action: ScreenShowStoreProductAction<Current>(
                storeProduct: storeProduct,
                animated: animated
            ),
            nested: route
        )
    }

    /// Present a view controller that provides a page where the user can purchase media from the App Store.
    /// - Parameters:
    ///   - storeProduct: An object for configuring the page.
    ///   - animated: Pass `true` to animate the presentation; otherwise, pass `false`.
    ///   - route: Nested route to be performed in the `SKStoreProductViewController`.
    /// - Returns: An instance containing the new action.
    public func showStoreProduct(
        _ storeProduct: StoreProduct,
        animated: Bool = true,
        route: (
            _ route: ScreenRootRoute<SKStoreProductViewController>
        ) -> ScreenRouteConvertible = { $0 }
    ) -> Self {
        showStoreProduct(
            storeProduct,
            animated: animated,
            route: route(.initial).route()
        )
    }
}
#endif
