#if canImport(UIKit) && canImport(StoreKit) && os(iOS)
import UIKit
import StoreKit

internal final class StoreProductManager:
    NSObject,
    SKStoreProductViewControllerDelegate {

    private let storeProduct: StoreProduct

    internal init(storeProduct: StoreProduct) {
        self.storeProduct = storeProduct
    }

    internal func productViewControllerDidFinish(
        _ viewController: SKStoreProductViewController
    ) {
        storeProduct.didFinish?()
    }
}

#endif
