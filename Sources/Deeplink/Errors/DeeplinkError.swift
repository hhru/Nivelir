import Foundation

/// A protocol representing an error that occurs when processing deeplinks.
public protocol DeeplinkError: Error, CustomStringConvertible {

    var isWarning: Bool { get }
}

extension DeeplinkError {

    public var isWarning: Bool {
        false
    }
}
