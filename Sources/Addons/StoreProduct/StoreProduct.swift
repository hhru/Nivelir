#if canImport(UIKit) && canImport(StoreKit) && os(iOS)
import UIKit
import StoreKit

public struct StoreProduct: CustomStringConvertible {

    public let itemID: String
    public let parameters: [String: Any]

    public let didInitialize: ((_ container: SKStoreProductViewController) -> Void)?
    public let didFinish: (() -> Void)?

    public var description: String {
        "StoreProduct(\(parameters))"
    }

    public init(
        itemID: String,
        parameters: [String: Any],
        didInitialize: ((_ container: SKStoreProductViewController) -> Void)? = nil,
        didFinish: (() -> Void)? = nil
    ) {
        self.itemID = itemID
        self.parameters = parameters
        self.didInitialize = didInitialize
        self.didFinish = didFinish
    }
}
#endif
