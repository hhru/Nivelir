import Foundation

/// А screen key that can be used to search for a container in the container hierarchy.
///
/// Usually you don't need to create an instance of this type.
/// It can be obtained from the `key` property of the `Screen` protocol.
///
/// - SeeAlso: `Screen`.
/// - SeeAlso: `ScreenKeyedContainer`.
public struct ScreenKey: Equatable, CustomStringConvertible {

    /// Screen name.
    public let name: String

    /// Screen traits that are used to distinguish screens with the same name.
    public let traits: Set<AnyHashable>

    public var description: String {
        let traits = self.traits.map { $0.base }

        return traits.isEmpty
            ? name
            : "\(name)(\(traits))"
    }

    /// Creates screen key.
    ///
    /// - Parameters:
    ///   - name: Screen name.
    ///   - traits: Screen traits that are used to distinguish screens with the same name.
    public init(name: String, traits: Set<AnyHashable> = []) {
        self.name = name
        self.traits = traits
    }
}
