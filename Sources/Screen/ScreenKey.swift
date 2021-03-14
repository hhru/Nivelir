import Foundation

public struct ScreenKey: Equatable, CustomStringConvertible {

    public let name: String
    public let traits: Set<AnyHashable>

    public var description: String {
        traits.isEmpty ? name : "\(name) \(traits)"
    }

    public init(name: String, traits: Set<AnyHashable> = []) {
        self.name = name
        self.traits = traits
    }
}
