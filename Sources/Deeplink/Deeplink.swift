import Foundation

public protocol Deeplink: AnyDeeplink {

    associatedtype Context
    associatedtype Routes

    func navigate(routes: Routes?, handler: DeeplinkHandler) throws
}

extension Deeplink {

    internal static func resolveContext(_ context: Any?) throws -> Context? {
        guard let context = context else {
            return nil
        }

        guard let context = context as? Context else {
            throw DeeplinkInvalidContextError(context: context, type: Context.self, for: self)
        }

        return context
    }

    public func navigateIfPossible(routes: Any?, handler: DeeplinkHandler) throws {
        guard let routes = routes else {
            return try navigate(routes: nil, handler: handler)
        }

        guard let routes = routes as? Routes else {
            throw DeeplinkInvalidRoutesError(routes: routes, type: Routes.self, for: self)
        }

        try navigate(routes: routes, handler: handler)
    }
}
