import Foundation

/// The container does not match the expected type.
///
/// This error occurs whenever any navigation action fails to cast the container to the specified type.
public struct ScreenContainerTypeMismatchError: ScreenError {

    public var description: String {
        """
        Could not cast container \(container) to \(type) for:
          \(trigger)
        """
    }

    /// Container that does not match the expected type
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
