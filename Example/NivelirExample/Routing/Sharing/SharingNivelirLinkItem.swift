import Foundation
import Nivelir

struct SharingNivelirLinkItem: SharingCustomItem {

    let url = URL(string: "https://github.com/hhru/Nivelir")!

    var placeholder: Any {
        url
    }

    func value(for activityType: SharingActivityType?) -> Any? {
        guard let activityType = activityType else {
            return url
        }

        switch activityType {
        case .copyToPasteboard, .openInBrowser:
            return url

        default:
            return """
            Nivelir: \(url)

            Send from iOS device.
            """
        }
    }

    func subject(for activityType: SharingActivityType?) -> String? {
        "Nivelir: \(url)"
    }
}

extension SharingItem {

    static var nivelirLink: Self {
        .custom(SharingNivelirLinkItem())
    }
}
