import Foundation

/// Interceptor for additional actions before performing navigation for ``Deeplink``.
///
/// The interceptor can be useful, for example,
/// for sending analytics events or additional API requests when performing ``Deeplink``.
public protocol DeeplinkInterceptor {

    /// Closure with the result of a ``Deeplink`` interception.
    typealias Completion = (Result<Void, Error>) -> Void

    /// ``Deeplink`` interception.
    ///
    /// The method is called before every deeplink performance.
    /// It is **required** to handle the result of the intercept via the `completion` parameter.
    /// A deeplink can be canceled if the interceptor returns an error in `completion`.
    /// - Parameters:
    ///   - deeplink: Erased type of ``Deeplink``. Cast or check the type if needed.
    ///   - type: ``DeeplinkType`` of the intercepted ``Deeplink``.
    ///   - navigator: Navigator for performing navigation actions.
    ///   - completion: Interceptor result. If `.success`, the intercepted ``Deeplink`` will be performed,
    ///   otherwise cancelled.
    func interceptDeeplink(
        _ deeplink: AnyDeeplink,
        of type: DeeplinkType,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    )
}
