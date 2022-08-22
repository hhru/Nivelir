#if canImport(UIKit)
import UIKit

/// An action that prepares an email to be sent using the default email client.
public struct ScreenMailAction<Container: ScreenContainer>: ScreenAction {

    public typealias Output = Void

    public let emailAddress: String
    public let subject: String?
    public let body: String?

    public init(
        emailAddress: String,
        subject: String?,
        body: String?
    ) {
        self.emailAddress = emailAddress
        self.subject = subject
        self.body = body
    }

    public func perform(
        container: Container,
        navigator: ScreenNavigator,
        completion: @escaping Completion
    ) {
        let urlQuerySubject = subject.map { URLQueryItem(name: "subject", value: $0) }
        let urlQueryBody = body.map { URLQueryItem(name: "body", value: $0) }

        var urlComponents = URLComponents()

        urlComponents.scheme = "mailto"
        urlComponents.path = emailAddress

        urlComponents.queryItems = [
            urlQuerySubject,
            urlQueryBody
        ].compactMap { $0 }

        guard let url = urlComponents.url else {
            return completion(.invalidMailParameters(for: self))
        }

        ScreenOpenURLAction(url: url).perform(
            container: container,
            navigator: navigator,
            completion: completion
        )
    }
}

extension ScreenThenable {

    /// Sending an email, with address, subject, and text, using the default email client.
    /// - Parameters:
    ///   - emailAddress: Email address.
    ///   - subject: Subject of the email.
    ///   - body: Email text.,
    /// - Returns: An instance containing the new action.
    public func mail(
        to emailAddress: String,
        subject: String? = nil,
        body: String? = nil
    ) -> Self {
        then(
            ScreenMailAction(
                emailAddress: emailAddress,
                subject: subject,
                body: body
            )
        )
    }
}
#endif
