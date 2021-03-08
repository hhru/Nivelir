#if canImport(UIKit)
import UIKit

public struct ScreenDismissAction<Container: UIViewController>: ScreenAction {

    public typealias Output = Void

    public let animated: Bool

    public init(animated: Bool = true) {
        self.animated = animated
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        navigation.logger?.info("Dismissing screen presented by \(container)")

        guard container.presented != nil else {
            return completion(.success)
        }

        container.dismiss(animated: animated) {
            completion(.success)
        }
    }
}

extension ScreenRoute where Container: UIViewController {

    public func dismiss(animated: Bool = true) -> Self {
        then(action: ScreenDismissAction<Container>(animated: animated))
    }
}
#endif
