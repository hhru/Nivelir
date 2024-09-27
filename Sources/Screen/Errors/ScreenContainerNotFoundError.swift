import Foundation

/// No container found.
///
/// This error occurs whenever an action fails to find the container.
public struct ScreenContainerNotFoundError: ScreenError {

    public let description: String

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - type: The type of container that could not be found.
    ///   - trigger: The action that caused the error.
    public init(type: Any.Type, for trigger: Any) {
        description = """
        No container of \(type) type found for:
          \(trigger)
        """
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
