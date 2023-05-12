import Foundation

internal class NotificationObserver {

    private var token: NSObjectProtocol?

    internal let center: NotificationCenter
    internal let name: Notification.Name
    internal let queue: OperationQueue?
    internal let handler: ((_ notification: Notification) -> Void)?

    internal init(
        center: NotificationCenter = .default,
        name: Notification.Name,
        queue: OperationQueue? = nil,
        handler: ((_ notification: Notification) -> Void)?
    ) {
        self.center = center
        self.name = name
        self.queue = queue
        self.handler = handler

        self.token = center.addObserver(forName: name, object: nil, queue: queue) { [weak self] notification in
            self?.handler?(notification)
        }
    }

    deinit {
        if let token {
            center.removeObserver(token)
        }
    }
}
