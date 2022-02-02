import Foundation

extension Collection {

    internal subscript(safe index: Index) -> Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }
}
