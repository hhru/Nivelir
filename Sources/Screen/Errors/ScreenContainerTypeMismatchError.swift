import Foundation

/// The type of the container does not match the expected type.
///
/// This error occurs whenever any action fails to cast the container to the expected type.
public struct ScreenContainerTypeMismatchError: ScreenError {

    public var description: String {
        """
        The type of the container \(container) does not match the expected type \(type) for:
          \(trigger)
        """
    }

    /// Container that does not match the expected type.
    public let container: ScreenContainer

    /// Expected container type
    public let type: Any.Type

    /// The action that caused the error.
    public let trigger: Any

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - container: Container that does not match the expected type.
    ///   - type: Expected container type.
    ///   - trigger: The action that caused the error.
    public init(container: ScreenContainer, type: Any.Type, for trigger: Any) {
        self.container = container
        self.type = type
        self.trigger = trigger
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
