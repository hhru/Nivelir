#if canImport(UIKit) && canImport(StoreKit) && os(iOS)
import UIKit

public struct StoreProduct: CustomStringConvertible {

    public let itemID: String
    public let parameters: [String: Any]
    public let didFinish: (() -> Void)?

    public var description: String {
        "StoreProduct(\(parameters))"
    }

    public init(
        itemID: String,
        parameters: [String: Any],
        didFinish: (() -> Void)? = nil
    ) {
        self.itemID = itemID
        self.parameters = parameters
        self.didFinish = didFinish
    }
}
#endif
