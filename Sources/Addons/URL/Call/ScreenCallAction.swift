#if canImport(UIKit) && os(iOS)
import UIKit

/// Actions with the display of a prompt to call the phone number.
public struct ScreenCallAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public let phoneNumber: String

    public init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        let phoneNumber = self.phoneNumber
            .removingPercentEncoding?
            .components(separatedBy: CharacterSet(charactersIn: "+0123456789").inverted)
            .joined() ?? ""

        var urlComponents = URLComponents()

        urlComponents.scheme = "tel"
        urlComponents.host = phoneNumber

        guard let url = urlComponents.url else {
            return completion(.invalidCallParameters(for: self))
        }

        ScreenOpenURLAction(url: url).perform(
            container: container,
            navigator: navigator,
            completion: completion
        )
    }
}

extension ScreenThenable {

    /// Calling a phone number using the `tel://` scheme.
    /// - Parameter phoneNumber: Phone number in any format.
    /// The action will remove encoding and extra characters from the string.
    /// - Returns: An instance containing the new action.
    public func call(to phoneNumber: String) -> Self {
        then(ScreenCallAction(phoneNumber: phoneNumber))
    }
}
#endif
