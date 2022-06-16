#if canImport(UIKit) && os(iOS)
import UIKit

public protocol SharingCustomActivity {

    static var category: SharingActivityCategory { get }

    var type: SharingActivityType? { get }
    var title: String { get }
    var image: UIImage { get }

    func isApplicable(for items: [SharingItem]) -> Bool
}

extension SharingCustomActivity {

    public static var category: SharingActivityCategory {
        .action
    }

    public var type: SharingActivityType? {
        nil
    }
}
#endif
