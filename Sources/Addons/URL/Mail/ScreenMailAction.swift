#if canImport(UIKit)
import UIKit

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

extension ScreenRoute {

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
