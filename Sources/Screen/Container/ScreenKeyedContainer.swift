import Foundation

/// A screen container that can be found in the container hierarchy by its key.
///
/// Implement this protocol in your container class if you want to find it in the container hierarchy.
/// For example:
///
/// ``` swift
/// class SomeViewController: ScreenKeyedContainer {
///
///     let screenKey: ScreenKey
///
///     init(screenKey: ScreenKey) {
///         self.screenKey = screenKey
///
///         super.init(nibName: nil, bundle: nil)
///     }
///
///     required init?(coder: NSCoder) {
///         fatalError("init(coder:) has not been implemented")
///     }
/// }
/// ```
///
/// The screen key can be obtained from the `key` property of the `Screen` protocol.
/// For example:
///
/// ``` swift
/// struct SomeScreen: Screen {
///
///     func build(navigator: ScreenNavigator) -> UIViewController {
///         SomeViewController(screenKey: key)
///     }
/// }
/// ```
///
/// To find a container in the hierarchy just use its key in the action predicates:
///
/// ``` swift
/// navigator.navigate { route in
///     route
///         .top(.container(key: someScreen.key))
///         .presenting
///         .dismiss()
/// }
/// ```
///
/// - SeeAlso: `Screen`
/// - SeeAlso: `ScreenKey`
/// - SeeAlso: `ScreenContainer`
public protocol ScreenKeyedContainer: ScreenContainer {

    /// Screen key that is used to find the container in the container hierarchy.
    var screenKey: ScreenKey { get }
}
