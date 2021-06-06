import Foundation

/// No container found.
///
/// This error occurs whenever any navigation action fails to find the container.
public struct ScreenContainerNotFoundError: ScreenError {

    public var description: String {
        """
        No container of \(type) type found for:
          \(trigger)
        """
    }

    /// The type of container that could not be found.
    public let type: Any.Type

    /// The action that caused the error.
    public let trigger: Any

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - type: The type of container that could not be found.
    ///   - trigger: The action that caused the error.
    public init(type: Any.Type, for trigger: Any) {
        self.type = type
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func containerNotFound(type: Any.Type, for trigger: Any) -> Self {
        .failure(
            ScreenContainerNotFoundError(
                type: type,
                for: trigger
            )
        )
    }
}
