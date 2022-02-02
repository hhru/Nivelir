import Foundation

struct ServiceKey: Hashable {

    let type: Any.Type
    let name: String
    let traits: [AnyHashable]

    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(type).hash(into: &hasher)
        name.hash(into: &hasher)
        traits.hash(into: &hasher)
    }
}

extension ServiceKey: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        (lhs.type == rhs.type)
            && (lhs.name == rhs.name)
            && (lhs.traits == rhs.traits)
    }
}
