import Foundation

/// The type of the container does not match the expected type.
///
/// This error occurs whenever an action fails to cast the container to the expected type.
public struct ScreenContainerTypeMismatchError: ScreenError {

    public let description: String

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - container: Container that does not match the expected type.
    ///   - type: Expected container type.
    ///   - trigger: The action that caused the error.
    public init(container: ScreenContainer, type: Any.Type, for trigger: Any) {
        description = """
        The type of the container \(container) does not match the expected type \(type) for:
          \(trigger)
        """
    }
}

extension Result where Failure == Error {

    internal static func containerTypeMismatch(
        _ container: ScreenContainer,
        type: Any.Type,
        for trigger: Any
    ) -> Self {
        .failure(
            ScreenContainerTypeMismatchError(
                container: container,
                type: type,
                for: trigger
            )
        )
    }
}
