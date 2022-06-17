import Foundation

extension Collection {

    internal var nonEmpty: Self? {
        isEmpty ? nil : self
    }

    internal subscript(safe index: Index) -> Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }
}
