import Foundation

public protocol ScreenCustomKey: CustomStringConvertible {
    func isEqual(to other: ScreenCustomKey) -> Bool
}

extension ScreenCustomKey where Self: Equatable {

    public func isEqual(to other: ScreenCustomKey) -> Bool {
        guard let other = other as? Self else {
            return false
        }

        return self == other
    }
}
