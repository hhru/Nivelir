#if canImport(UIKit) && canImport(StoreKit) && os(iOS)
import UIKit
import StoreKit

/// An object for configuring the page where the user can purchase media from the App Store.
public struct StoreProduct: CustomStringConvertible {

    /// An iTunes item identifier.
    public let itemID: String

    /// A dictionary describing the content you want the view controller to display.
    public let parameters: [String: Any]

    /// A closure that returns the created `SKStoreProductViewController` in the argument.
    public let didInitialize: ((_ container: SKStoreProductViewController) -> Void)?

    /// Called when the user dismisses the store screen.
    public let didFinish: (() -> Void)?

    public var description: String {
        "StoreProduct(\(parameters))"
    }

    /// Creates a configuration.
    /// - Parameters:
    ///   - itemID: An iTunes item identifier.
    ///   - parameters: A dictionary describing the content you want the view controller to display.
    ///   - didInitialize: A closure that returns the created `SKStoreProductViewController` in the argument.
    ///   - didFinish: Called when the user dismisses the store screen.
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
