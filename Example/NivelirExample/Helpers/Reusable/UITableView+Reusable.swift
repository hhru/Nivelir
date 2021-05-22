import UIKit

extension UITableView {

    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView & Reusable>(of type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView & Reusable>(of type: T.Type) -> T {
        dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
    }

    func registerReusableCell<T: UITableViewCell & Reusable>(of type: T.Type) {
        register(type, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell & Reusable>(of type: T.Type) -> T {
        dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
    }

    func dequeueReusableCell<T: UITableViewCell & Reusable>(of type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
