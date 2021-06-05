import Foundation

extension RangeReplaceableCollection {

    internal mutating func prepend<T: Collection>(contentsOf collection: T) where Self.Element == T.Element {
        insert(contentsOf: collection, at: startIndex)
    }

    internal mutating func prepend(_ element: Element) {
        insert(element, at: startIndex)
    }

    internal func prepending<T: Collection>(contentsOf collection: T) -> Self where Self.Element == T.Element {
        collection + self
    }

    internal func prepending(_ element: Element) -> Self {
        prepending(contentsOf: [element])
    }

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
