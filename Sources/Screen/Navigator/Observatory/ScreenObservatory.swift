import Foundation

/// A type that adds observers for subscribe to notifications from observation.
///
<<<<<<< HEAD
/// With `ScreenObservatory`, any screen can observing changes of another screen using an observer.
=======
/// With `ScreenObservatory`, any screen can observe changes of another screen using an observer.
>>>>>>> cb35260bfcd34305b6def01b58f3bdec08361150
/// The observer can be the `UIViewController` itself, which wants to receive new notifications,
/// or for example in case of using MVVM architecture,
/// the observer can be a ViewModel (or Presenter for VIPER).
/// In this case ViewModel/Presenter will receive new notifications and perform necessary business logic.
///
/// In usual cases, a closure or delegate is passed to receive changes from a screen.
/// But if the navigation is a chain of screens,
/// then passing closure/delegate from the first to the last screen through all screens in the chain is difficult.
/// And such a chain is difficult to collect via deeplink.
///
/// **Example**
///
<<<<<<< HEAD
/// For example, we have three screens: `EmployerRewiewList`, `EmployerReview`, `EmployerReviewDeletion`.
/// `EmployerRewiewList` shows `EmployerReview` and `EmployerReviewDeletion` screen,
/// and `EmployerReview` can show `EmployerReviewDeletion`. This results in the following diagram:
///
/// ```
/// EmployerRewiewList ---------------> EmployerReview
=======
/// For example, we have three screens: `EmployerReviewList`, `EmployerReview`, `EmployerReviewDeletion`.
/// `EmployerReviewList` shows `EmployerReview` and `EmployerReviewDeletion` screen,
/// and `EmployerReview` can show `EmployerReviewDeletion`. This results in the following diagram:
///
/// ```
/// EmployerReviewList ---------------> EmployerReview
>>>>>>> cb35260bfcd34305b6def01b58f3bdec08361150
///         |                                   |
///         |                                   |
///          ----> EmployerReviewDeletion <-----
/// ```
///
<<<<<<< HEAD
/// `EmployerReview` and `EmployerRewiewList` should update their data when the `EmployerReviewDeletion` screen changes.
/// Such a chain is difficult to maintain and difficult to implement when opening screens through a deep link.
///
/// Instead, `EmployerReview` and `EmployerRewiewList` can become observers of the `EmployerReviewDeletion` screen.
=======
/// `EmployerReview` and `EmployerReviewList` should update their data when the `EmployerReviewDeletion` screen changes.
/// Such a chain is difficult to maintain and difficult to implement when opening screens through a deep link.
///
/// Instead, `EmployerReview` and `EmployerReviewList` can become observers of the `EmployerReviewDeletion` screen.
>>>>>>> cb35260bfcd34305b6def01b58f3bdec08361150
/// To do this, you need to create a protocol for `EmployerReviewDeletion` screen observers:
///
/// ```swift
/// protocol EmployerReviewDeletionObserver: ScreenObserver {
///     func employerReviewDeleted(employerReviewID: Int)
/// }
/// ```
///
/// `EmployerReviewDeletion` will notify its observers that a employer review with a specific ID has been deleted.
/// To send a notification to observers, use `ScreenObservation`, which is available when building a screen:
///
/// ```swift
/// struct EmployerReviewDeletionScreen: Screen {
///     func build(
///         navigator: ScreenNavigator,
///         observation: ScreenObservation<EmployerReviewDeletionObserver> // <---
///     ) -> UIViewController {
///         // Configure dependencies for the UIViewController.
///     }
/// }
/// ```
///
/// The `ScreenObservation` can be passed to, for example,
/// the `UIViewController` or the ViewModel/Presenter.
/// To send a notification, use the `notify(_:)` method:
///
/// ```swift
/// let observation: ScreenObservation<EmployerReviewDeletionObserver>
///
/// observation.notify { observer in
///     observer.employerReviewDeleted(employerReviewID: 2)
/// }
/// ```
///
/// Or you can use the short syntax due to the `callAsFunction(_:)` function:
///
/// ```swift
/// let observation: ScreenObservation<EmployerReviewDeletionObserver>
///
/// observation { observer in
///     observer.employerReviewDeleted(employerReviewID: 2)
/// }
/// ```
///
<<<<<<< HEAD
/// Now in order for the `EmployerRewiewList` and `EmployerReview` screens
=======
/// Now in order for the `EmployerReviewList` and `EmployerReview` screens
>>>>>>> cb35260bfcd34305b6def01b58f3bdec08361150
/// to start observing the `EmployerReviewDeletion`,
/// the `EmployerReviewDeletionObserver` protocol must be implemented.
/// It can be implemented by, for example, `UIViewController` or ViewModel/Presenter.
/// After that, you need to add an observer to observatory using one of the `ScreenObservatory` methods,
/// where the class implementing the `EmployerReviewDeletionObserver` protocol is passed in the `observer` parameter.
/// For observers, the `employerReviewDeleted(employerReviewID:)` method
/// will be called as soon as the observation notifies it.
///
/// Thus, we subscribed several observers for one screen.
///
/// - SeeAlso: `ScreenObserver`
/// - SeeAlso: `ScreenObservation`
/// - SeeAlso: `ScreenObserverPredicate`
public protocol ScreenObservatory {

    /// Observing containers by an observer.
    /// The observer will receive new notifications until the end of its life cycle.
    /// After the observer is deinited, it will stop receiving new notifications.
    /// - Parameters:
    ///   - observer: A class that implements the `ScreenObserver` protocol that will receive new notifications.
    ///   - predicate: Predicate allows you to limit from which sources new notifications are received.
    ///   By specifying `.any` the observer will receive notifications from all sources.
    func observeWeakly(
        by observer: ScreenObserver,
        where predicate: ScreenObserverPredicate
    )

    /// Observing containers by an observer.
    /// - Parameters:
    ///   - observer: A class that implements the `ScreenObserver` protocol that will receive new notifications.
    ///
    ///   - predicate: Predicate allows you to limit from which sources new notifications are received.
    ///   By specifying `.any` the observer will receive notifications from all sources.
    ///
    ///   - weakly: Sets how the observer is captured in memory.
    ///   If set to `false`, the observer will receive new notifications and is captured by the **strong reference**
    ///   until the `cancel()` or `deinit` method of the `ScreenObserverToken` is called,
    ///   which returns this function.
    ///   If `true` is set, the observer will be captured by the **weak reference**
    ///    and will stop receiving notifications after observer is deinited or cancellation with the token.
    ///
    /// - Returns: A token that allows to cancel a subscription.
    /// The subscription is automatically canceled when the token is deinited.
    func observe(
        by observer: ScreenObserver,
        where predicate: ScreenObserverPredicate,
        weakly: Bool
    ) -> ScreenObserverToken

    /// Observing containers by an observer.
    /// Еhe observer will receive new notifications and is captured by the **strong reference**
    /// until the `cancel()` or `deinit` method of the `ScreenObserverToken` is called
    /// - Parameters:
    ///   - observer: A class that implements the `ScreenObserver` protocol that will receive new notifications.
    ///   - predicate: Predicate allows you to limit from which sources new notifications are received.
    ///   By specifying `.any` the observer will receive notifications from all sources.
    /// - Returns: A token that allows to cancel a subscription.
    /// The subscription is automatically canceled when the token is deinited.
    func observe(
        by observer: ScreenObserver,
        where predicate: ScreenObserverPredicate
    ) -> ScreenObserverToken

    /// Creates a new `ScreenObservation`, which sends notifications to subscribed observers.
    /// - Parameter type: The type of observer that will receive notifications.
    /// - Returns: New `ScreenObservation'.
    func observation<Observer>(
        of type: Observer.Type,
        iterator: ScreenIterator
    ) -> ScreenObservation<Observer>
}
