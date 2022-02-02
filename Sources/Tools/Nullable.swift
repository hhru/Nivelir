import Foundation

internal protocol Nullable {

    static var none: Self { get }
}

extension Optional: Nullable { }
