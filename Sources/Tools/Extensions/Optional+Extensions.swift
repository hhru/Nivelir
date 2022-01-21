import Foundation

extension Optional {

    internal var isNil: Bool {
        self == nil
    }
}

extension Optional where Wrapped: Collection {

    internal var isEmptyOrNil: Bool {
        self?.isEmpty ?? true
    }
}
