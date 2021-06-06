import Foundation

/// Payload associated with the screen container.
///
/// This is a helper class that is used to store navigation data
/// that should be in memory until the screen container itself is released.
///
/// - SeeAlso: `ScreenPayloadContainer`
public final class ScreenPayload {

    private var storage: [Any] = []

    /// Creates an empty payload.
    public init() { }

    /// Stores navigation data.
    ///
    /// - Parameter data: Navigation data.
    public func store(_ data: Any) {
        storage.append(data)
    }
}
