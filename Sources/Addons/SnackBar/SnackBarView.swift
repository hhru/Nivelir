import Foundation

final class SnackBarView: UIView {

    private let contentView = UIView()

    private var animation: HUDAnimation?
    private var timer: Timer?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event).flatMap { view in
            view == self ? nil : view
        }
    }

}
