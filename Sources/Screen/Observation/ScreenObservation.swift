import Foundation

/// The `ScreenObservation` sends notifications to observers with the type `Observer`.
///
/// The `ScreenObservation` with the generic type `Observer`
/// is available for any `Screen` when it is built in the `build(navigator:,observation:)` method:
///
/// ```swift
/// struct AuthorizationScreen: Screen {
///     func build(
///         navigator: ScreenNavigator,
///         observation: ScreenObservation<AuthorizationObserver> // <----
///     ) -> UIViewController {
///         AuthorizationViewController(
///             screenObservation: observation,
///             screenKey: key,
///             screenNavigator: navigator
///         )
///     }
/// }
/// ```
///
/// Where in this example `AuthorizationObserver` is a protocol inherited from `ScreenObserver`,
/// which is implemented by observers and subscribed through the navigator method `observe(by:,where:)`:
///
/// ```swift
/// protocol AuthorizationObserver: ScreenObserver {
///     func authorizationFinished(isAuthorized: Bool)
/// }
/// ```
///
/// - SeeAlso: ``ScreenObserver``
/// - SeeAlso: ``ScreenObservatory``
public class ScreenObservation<Observer> {

    private var container: ScreenContainerStorage?
    private let observers: (_ container: ScreenContainer?) -> [Observer]

    internal init(observers: @escaping (_ container: ScreenContainer?) -> [Observer]) {
        self.observers = observers
    }

    internal func associate(with container: ScreenContainer) {
        if let container = container as? (ScreenContainer & AnyObject) {
            self.container = ScreenContainerWeakStorage(container)
        } else {
            self.container = ScreenContainerSharedStorage(container)
        }
    }

    /// Sending a notification to observers.
    ///
    /// This method allows to get observers
    /// who are observing the `ScreenObservation` screen to send a notification through a method call.
    ///
    /// ```swift
    /// protocol AuthorizationObserver: ScreenObserver {
    ///     func authorizationFinished(isAuthorized: Bool)
    /// }
    ///
    /// let observation: ScreenObservation<AuthorizationObserver>
    ///
    /// observation.notify { observer in
    ///     observer.authorizationFinished(isAuthorized: true)
    /// }
    /// ```
    ///
    /// - Parameter body: Closure, which takes an observer as an argument to call its methods.
    public func notify(_ body: (_ observer: Observer) throws -> Void) rethrows {
        try observers(container?.value).forEach(body)
    }

    /// Shortened syntax for calling the `notify(_:)` function.
    ///
    /// ```swift
    /// protocol AuthorizationObserver: ScreenObserver {
    ///     func authorizationFinished(isAuthorized: Bool)
    /// }
    ///
    /// let observation: ScreenObservation<AuthorizationObserver>
    ///
    /// observation { observer in
    ///     observer.authorizationFinished(isAuthorized: true)
    /// }
    /// ```
    public func callAsFunction(_ body: (_ observer: Observer) throws -> Void) rethrows {
        try notify(body)
    }
}
