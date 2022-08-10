import Foundation

/// A route that describes navigation as a set of actions.
///
/// `ScreenRoute` is built from a set of navigation actions
/// and contains the root and the current container type on which these actions will be performed.
/// The actions that can be added to route are constrained to the current container type.
///
/// **Navigation Chains**
///
/// Navigation actions can be described as a chain:
///
/// ```swift
/// let navigator: ScreenNavigator
///
/// navigator.navigate { route in
///     route
///         .top(.stack)
///         .popToRoot()
///         .push(SomeScreen(color: .red))
///         .push(SomeScreen(color: .green)) { route in
///             route.present(SomeScreen(color: .blue))
///         }
/// }
/// ```
///
/// This navigation performs the following steps:
///
/// 1) Search for the topmost container of the stack (UINavigationController)
/// 2) Resetting its stack to the first screen
/// 3) Adding a red screen to the stack
/// 4) Adding a green screen to the stack
/// 5) Presenting a blue screen on the green screen modally
///
/// Navigation actions can extend the `ScreenThenable` protocol
/// with specifying the type of container on which it can be performed:
///
/// ```swift
/// extension ScreenThenable where Current: UIViewController {
///     func customAction() -> Self {
///         then(
///             ScreenCustomAction<Current>()
///         )
///     }
/// }
/// ```
///
/// This will make it easy to add the navigation action to the chain:
///
/// ```swift
/// let navigator: ScreenNavigator
///
/// navigator.navigate { route in
///     route
///         .top(.container)
///         .customAction() // <----
///         .tabs
///         .top(.stack)
///         .push(SomeScreen(color: .red))
/// }
/// ```
///
/// Each action in the chain can throw an exception.
/// This exception can be caught and perform other navigation actions:
///
/// ```swift
/// let screen = ChatScreen(chatID: 2)
///
/// let pushRoute = ScreenWindowRoute()
///     .top(.stack)
///     .push(screen)
///
/// let viewRoute = ScreenWindowRoute()
///     .last(.container(of: screen))
///     .makeVisible()
///     .fallback(to: pushRoute) // <----
/// ```
///
/// In this example route perform the following steps:
/// 1) Find the chat screen with `chatID = 2` in the screen hierarchy starting from `UIWindow`
/// 2) Navigate to the screen (see `ScreenMakeVisibleAction`)
/// 3) In case the screen is not found or there was an error when showing the screen,
/// the chain will perform an alternate `pushRoute` which:
///     1) Searches the top `UINavigationController`
///     2) Adds a chat screen to the stack
///
/// The `fallback` also allows you to get `error`,
/// and depending on its type you can build different navigation:
///
/// ```swift
/// let navigator: ScreenNavigator
///
/// let mediaPicker = MediaPicker(source: .camera) { result in
///     // Handle result
/// }
///
/// navigator.navigate(from: self) { route in
///     route
///         .showMediaPicker(mediaPicker)
///         .fallback { error, route in
///             switch error {
///             case is MediaPickerSourceAccessDeniedError:
///                 return route.showAlert(.cameraPermissionRequired)
///
///             case is UnavailableMediaPickerSourceError:
///                 return route.showAlert(.unavailableMediaSource)
///
///             case is UnavailableMediaPickerTypesError:
///                 return route.showAlert(.unavailableMediaTypes)
///
///             default:
///                 return route.showAlert(.somethingWentWrong)
///             }
///         }
/// }
/// ```
///
/// - SeeAlso: `ScreenThenable`
/// - SeeAlso: `ScreenTryAction`
public struct ScreenRoute<
    Root: ScreenContainer,
    Current: ScreenContainer
>: ScreenThenable {

    internal typealias Resolver = (
        _ actions: [AnyScreenAction<Current, Void>]
    ) -> [AnyScreenAction<Root, Void>]

    internal let resolver: Resolver
    internal let tail: [AnyScreenAction<Current, Void>]

    public var actions: [AnyScreenAction<Root, Void>] {
        resolver(tail)
    }

    internal init(
        resolver: @escaping Resolver,
        tail: [AnyScreenAction<Current, Void>] = []
    ) {
        self.resolver = resolver
        self.tail = tail
    }

    public func then(_ actions: [AnyScreenAction<Current, Void>]) -> Self {
        let newTail = actions.reduce(into: tail) { actions, action in
            if let newAction = actions.last?.combine(with: action) {
                actions.removeLast()
                actions.append(newAction)
            } else {
                actions.append(action)
            }
        }

        return Self(
            resolver: resolver,
            tail: newTail
        )
    }

    public func then<Action: ScreenAction>(
        _ action: Action
    ) -> Self where Action.Container == Current {
        then([action.eraseToAnyVoidAction()])
    }

    public func then<Route: ScreenThenable>(
        _ other: Route
    ) -> Self where Route.Root == Current {
        then(other.actions)
    }

    /// Returns the root route with the actions of the current instance.
    ///
    /// - Returns: An instance containing all the actions.
    public func resolve() -> ScreenRootRoute<Root> {
        ScreenRootRoute(actions: actions)
    }
}
