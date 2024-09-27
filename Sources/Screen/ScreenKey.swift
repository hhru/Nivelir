import Foundation

/// А screen key that can be used to search for a container in the container hierarchy.
///
/// Usually you don't need to create an instance of this type.
/// It can be obtained from the `key` property of the `Screen` protocol.
///
/// - SeeAlso: `Screen`.
/// - SeeAlso: `ScreenKeyedContainer`.
public struct ScreenKey: Hashable, CustomStringConvertible, Sendable {

    /// Screen name.
    public let name: String

    /// Screen traits that are used to distinguish screens with the same name.
    public let traits: Set<AnyHashable>

    public let description: String

    /// Creates a screen key.
    ///
    /// - Parameters:
    ///   - name: Screen name.
    ///   - traits: Screen traits that are used to distinguish screens with the same name.
    public init(name: String, traits: Set<AnyHashable> = []) {
        self.name = name
        self.traits = traits
        let traits = self.traits.map { $0.base }
        description = traits.isEmpty
            ? name
            : "\(name)(\(traits))"
    }
}
