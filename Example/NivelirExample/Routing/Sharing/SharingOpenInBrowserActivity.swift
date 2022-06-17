import UIKit
import Nivelir

struct SharingOpenInBrowserActivity: SharingSilentActivity {

    var type: SharingActivityType? {
        .openInBrowser
    }

    var title: String {
        "Open in Browser"
    }

    var image: UIImage {
        Images.browser
    }

    private func resolveURL(from item: SharingItem) -> URL? {
        switch item {
        case let .regular(url as URL):
            return url

        case let .custom(item):
            return item.value(for: type) as? URL

        default:
            return nil
        }
    }

    private func resolveURL(from items: [SharingItem]) -> URL? {
        items
            .lazy
            .compactMap(resolveURL(from:))
            .first
    }

    func isApplicable(for items: [SharingItem]) -> Bool {
        resolveURL(from: items) != nil
    }

    func perform(
        for items: [SharingItem],
        navigator: ScreenNavigator,
        completion: @escaping (_ completed: Bool) -> Void
    ) {
        guard let url = resolveURL(from: items) else {
            return completion(false)
        }

        navigator.navigate(
            to: { route in
                route
                    .top(.container)
                    .showSafari(Safari(url: url))
            },
            completion: { _ in
                completion(true)
            }
        )
    }
}

extension SharingActivityType {

    static var openInBrowser: Self {
        fromPropertyName()
    }
}

extension SharingActivity {

    static var openInBrowser: Self {
        .custom(SharingOpenInBrowserActivity())
    }
}
