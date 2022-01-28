import Foundation

extension Dictionary {

    internal func updatingValue(_ value: Value, forKey key: Key) -> Self {
        var dictionary = self

        dictionary.updateValue(value, forKey: key)

        return dictionary
    }
}
