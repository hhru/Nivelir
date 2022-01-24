import Foundation

extension Result {

    internal func ignoringValue() -> Result<Void, Failure> {
        map { _ in Void() }
    }
}

extension Result where Success == Void {

    internal static var success: Self {
        .success(Void())
    }
}
