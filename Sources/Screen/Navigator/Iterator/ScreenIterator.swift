import Foundation

/// A type that iterates and searches through containers of screens with a given predicate.
public protocol ScreenIterator {

    /// Iterate through containers starting from a given `container` as long as the `predicate` condition holds.
    /// This method can be used to search for container using a custom `predicate`.
    /// - Parameters:
    ///   - container: The container from which the iteration starts.
    ///   - predicate: A predicate that determines whether to continue iterating or stop.
    /// - Returns: The container on which the predicate has stopped iterating.
    /// If the predicate has not stopped iterating until all containers have iterated, then this value will be `nil`.
    func iterate(
        from container: ScreenContainer,
        while predicate: ScreenIterationPredicate
    ) -> ScreenContainer?

    /// Returns the first container that satisfies the given `predicate`,
    /// starting the iteration from the given `container`.
    /// - Parameters:
    ///   - container: The container from which the iteration starts.
    ///   - predicate: A closure that takes a container as its argument
    ///   and returns a Boolean value indicating whether the element is a match.
    /// - Returns: The first container that satisfies `predicate`,
    /// or `nil` if there is no container that satisfies `predicate`.
    func firstContainer(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer?

    /// Returns the last container that satisfies the given `predicate`,
    /// starting the iteration from the given `container`.
    /// - Parameters:
    ///   - container: The container from which the iteration starts.
    ///   - predicate: A closure that takes a container as its argument
    ///   and returns a Boolean value indicating whether the element is a match.
    /// - Returns: The last container that satisfies `predicate`,
    /// or `nil` if there is no container that satisfies predicate.
    func lastContainer(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer?

    /// Returns the top (visible) container that satisfies the given `predicate`,
    /// starting the iteration from the given `container`.
    /// - Parameters:
    ///   - container: The container from which the iteration starts.
    ///   - predicate: A closure that takes a container as its argument
    ///   and returns a Boolean value indicating whether the element is a match.
    /// - Returns: The top (visible) container that satisfies `predicate`,
    /// or `nil` if there is no container that satisfies predicate.
    func topContainer(
        in container: ScreenContainer,
        where predicate: @escaping (_ container: ScreenContainer) -> Bool
    ) -> ScreenContainer?
}
