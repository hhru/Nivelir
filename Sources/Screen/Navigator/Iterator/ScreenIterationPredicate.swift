import Foundation

/// A closure box that takes a container as its argument and returns a `ScreenIterationResult` value,
/// indicating whether to continue or stop iterating.
public struct ScreenIterationPredicate {

    private let box: (_ container: ScreenContainer) -> ScreenIterationResult

    /// - Parameter box: A closure that takes a container as its argument and returns a `ScreenIterationResult` value,
    /// indicating whether to continue or stop iterating.
    public init(_ box: @escaping (_ container: ScreenContainer) -> ScreenIterationResult) {
        self.box = box
    }

    /// Returns a ScreenIterationResult value that indicates whether to continue or stop iterating.
    /// - Parameter container: The container against which to evaluate the predicate.
    /// - Returns: `ScreenIterationResult` with the iteration result.
    public func checkContainer(_ container: ScreenContainer) -> ScreenIterationResult {
        box(container)
    }
}
