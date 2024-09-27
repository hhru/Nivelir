import Foundation

/// Scope for splitting deep links.
///
/// The scope allows you to split deep links by activating and deactivating each scope independently.
/// See ``DeeplinkManager`` for details.
public struct DeeplinkScope: Hashable, ExpressibleByStringLiteral, Sendable {

    /// A unique key for identifying a scope.
    public let key: String?

    private init() {
        self.key = nil
    }

    /// Creating a scope with a unique key.
    /// - Parameter key: A unique key for identifying a scope.
    public init(key: String) {
        self.key = key
    }

    public init(stringLiteral key: String) {
        self.init(key: key)
    }
}

extension DeeplinkScope {

    /// The default scope.
    public static let `default` = Self()

    /// Creates a new scope using the variable name as a key.
    ///
    /// An example of creating a scope from a variable name. The name of the key will be `backURL`:
    ///
    /// ```swift
    /// extension DeeplinkScope {
    ///     public static var backURL: Self {
    ///         fromPropertyName()
    ///     }
    /// }
    /// ```
    ///
    /// This scope is available as a static property when used:
    ///
    /// ```swift
    /// let manager: DeeplinkManager
    ///
    /// manager.activate(screens: nil, scope: .backURL)
    /// ```
    /// - Parameter name: The name of the variable. The default is the literal `#function`.
    /// - Returns: A new scope, where the key is equal to the variable name.
    public static func fromPropertyName(_ name: String = #function) -> Self {
        Self(key: name)
    }
}
