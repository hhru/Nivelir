#if canImport(UIKit) && canImport(StoreKit) && os(iOS)
import UIKit
import StoreKit

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

        let storeProductContainer = SKStoreProductViewController()
        let storeProductManager = StoreProductManager(storeProduct: storeProduct)

        storeProductContainer.screenPayload.store(storeProductManager)
        storeProductContainer.delegate = storeProductManager

        guard let storeProductID = Int(storeProduct.itemID).map(NSNumber.init(value:)) else {
            return completion(.invalidStoreProductID(for: self))
        }

        let parameters = storeProduct
            .parameters
            .merging([SKStoreProductParameterITunesItemIdentifier: storeProductID]) { $1 }

        storeProductContainer.loadProduct(withParameters: parameters)

        container.present(storeProductContainer, animated: animated) {
            completion(.success(storeProductContainer))
        }
    }
}

extension ScreenThenable where Current: UIViewController {

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
