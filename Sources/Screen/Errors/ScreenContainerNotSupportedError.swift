import Foundation

/// The container type is not supported.
///
/// This error occurs whenever an action handles an unsupported container type.
public struct ScreenContainerNotSupportedError: ScreenError {

    public let description: String

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - container: Container that does not match the expected type.
    ///   - trigger: The action that caused the error.
    public init(container: ScreenContainer, for trigger: Any) {
        description = """
        The type of the container \(container) is not supported for:
          \(trigger)
        """
    }
}

extension Result where Failure == Error {

    internal static func containerNotSupported(
        _ container: ScreenContainer,
        for trigger: Any
    ) -> Self {
        .failure(
            ScreenContainerNotSupportedError(
                container: container,
                for: trigger
            )
        )
    }
}
