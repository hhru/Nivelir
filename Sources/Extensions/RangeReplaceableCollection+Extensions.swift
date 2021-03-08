import Foundation

extension RangeReplaceableCollection {

    internal func appending<T: Collection>(
        contentsOf collection: T
    ) -> Self where Self.Element == T.Element {
        self + collection
    }

    internal func appending(_ element: Element) -> Self {
        appending(contentsOf: [element])
    }

    internal func removingAll(where predicate: (Element) throws -> Bool) rethrows -> Self {
        var collection = self
        try collection.removeAll(where: predicate)

        return collection
    }
}
