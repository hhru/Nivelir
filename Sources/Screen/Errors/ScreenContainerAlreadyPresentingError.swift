import Foundation

/// The container is already presenting another container.
///
/// This error occurs whenever an action fails to present a modal container on a container
/// which is already presenting another container.
public struct ScreenContainerAlreadyPresentingError: ScreenError {

    public var description: String {
        """
        The container \(container) is already presenting another container for:
          \(trigger)
        """
    }

    /// Container that is already presenting another screen.
    public let container: ScreenContainer

    /// The action that caused the error.
    public let trigger: Any

    /// Creates an error.
    ///
    /// - Parameters:
    ///   - container: Container that is already presenting another screen.
    ///   - trigger: The action that caused the error.
    public init(container: ScreenContainer, for trigger: Any) {
        self.container = container
        self.trigger = trigger
    }
}

extension Result where Failure == Error {

    internal static func containerAlreadyPresenting(
        _ container: ScreenContainer,
        for trigger: Any
    ) -> Self {
        .failure(
            ScreenContainerAlreadyPresentingError(
                container: container,
                for: trigger
            )
        )
    }
}
