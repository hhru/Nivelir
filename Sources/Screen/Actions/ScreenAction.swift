import Foundation

/// A protocol representing the navigation action that is performed in the screen container.
public protocol ScreenAction {

    /// A type of container that the action uses for navigation.
    ///
    /// - SeeAlso: `ScreenContainer`
    associatedtype Container: ScreenContainer

    /// The type of value returned by the action.
    associatedtype Output

    /// The type of action state that must exist in memory until the action completes.
    ///
    /// - SeeAlso: `ScreenActionStorage`
    associatedtype State

    /// Alias for the closure that is called after the action is completed.
    typealias Completion = (Result<Output, Error>) -> Void

    /// Casts the instance to the specified type if it's possible to do so.
    ///
    /// This method is useful for casting instances of the `AnyScreenAction` type,
    /// because the standard `as` and `is` operators are unusable for them.
    /// For example, you can't do something like this:
    ///
    /// ``` swift
    /// let anyAction = ScreenDismissAction<UIViewController>().eraseToAnyScreen()
    ///
    /// if let dismissAction = anyAction as? ScreenDismissAction<UIViewController> {
    ///     print(dismissAction.animated)
    /// }
    /// ```
    ///
    /// The compiler will issue the following warning:
    ///
    /// ```
    /// Cast from 'AnyScreenAction<UIViewController, Void>'
    /// to unrelated type 'ScreenDismissAction<UIViewController>()' always fails
    /// ```
    ///
    /// In this case, you can use the `cast(to:)` method instead:
    ///
    /// ``` swift
    /// if let dismissAction = anyAction.cast(to: ScreenDismissAction<UIViewController>.self) {
    ///     print(dismissAction.animated)
    /// }
    /// ```
    ///
    /// Default implementation uses standard type casting.
    /// You don't need to implement this method yourself.
    ///
    /// - Parameter type: The type to which the instance will be cast.
    /// - Returns: An optional value of the type you are trying to cast to.
    func cast<Action: ScreenAction>(to type: Action.Type) -> Action?

    /// Сombines this action with another.
    ///
    /// Some navigation actions can be combined with others to form a single new action that does the same thing.
    /// For example, you need to push two view controllers into the navigation stack,
    /// this can be done by two calls to the `pushViewController(_:animated:)` method:
    ///
    /// ``` swift
    /// navigationController.pushViewController(firstViewController, animated: true)
    /// navigationController.pushViewController(secondViewController, animated: true)
    /// ```
    ///
    /// But such a transition will be ugly.
    /// It is better to combine two push actions into single call to the `setViewControllers(_:animated:)` method:
    ///
    /// ``` swift
    /// navigationController.setViewControllers([firstViewController, secondViewController], animated: true)
    /// ```
    ///
    /// You can implement combining such navigation actions in this method.
    /// Use the `cast(to:)` method to check the type of navigation action from the  `other` parameter
    /// and return `nil` if the actions cannot be combined:
    ///
    /// ``` swift
    /// guard let other = other.cast(to: SomeAction.self) else {
    ///     return nil
    /// }
    /// ```
    ///
    /// Default implementation returns `nil`.
    ///
    /// - Parameter other: Navigation action for combining.
    /// - Returns: A new navigation action that is a combination of the source actions
    ///            or `nil` if the combination is not possible.
    ///
    /// - SeeAlso: `cast(to:)`
    func combine<Action: ScreenAction>(
        with other: Action
    ) -> AnyScreenAction<Container, Void>?

    /// Performs action in the screen container.
    ///
    /// - Parameters:
    ///   - container: The screen container in which the navigation action is performed.
    ///   - navigator: The navigator that can be used to perform the action.
    ///   - completion: The closure that is called after the action is completed.
    ///                 This closure has no return value and takes the result of the navigation action.
    ///
    /// - SeeAlso: `ScreenNavigator`
    func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    )

    /// Performs action in the screen container.
    ///
    /// - Parameters:
    ///   - container: The screen container in which the navigation action is performed.
    ///   - navigator: The navigator that can be used to perform the action.
    ///   - storage: The storage for storing the state of the action until it completes.
    ///   - completion: The closure that is called after the action is completed.
    ///                 This closure has no return value and takes the result of the navigation action.
    ///
    /// - SeeAlso: `ScreenNavigator`
    /// - SeeAlso: `ScreenActionStorage`
    func perform(
        container: Container,
        navigator: ScreenNavigator,
        storage: ScreenActionStorage<State>,
        completion: @escaping Completion
    )
}

extension ScreenAction where State == Void {

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        storage: ScreenActionStorage<Void>,
        completion: @escaping Completion
    ) {
        perform(
            container: container,
            navigator: navigator,
            completion: completion
        )
    }
}

extension ScreenAction {

    public func cast<Action: ScreenAction>(to type: Action.Type) -> Action? {
        self as? Action
    }

    public func combine<Action: ScreenAction>(
        with other: Action
    ) -> AnyScreenAction<Container, Void>? {
        nil
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        let storage = ScreenActionStorage<State>()

        perform(
            container: container,
            navigator: navigator,
            storage: storage
        ) { result in
            storage.clear()

            completion(result)
        }
    }
}
