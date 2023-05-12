#if canImport(UIKit)
import UIKit

/// A view showing the activity indicator in the progress indicator.
public final class ProgressActivityIndicatorView: UIView, ProgressContentView {

    private enum Layout {
        static let size = CGSize(equilateral: 40.0)
    }

    private let activityIndicatorView: UIActivityIndicatorView = {
        if #available(iOS 13.0, tvOS 13.0, *) {
            return UIActivityIndicatorView(style: .medium)
        }

        return UIActivityIndicatorView(style: .whiteLarge)
    }()

    public let content: ProgressActivityIndicator

    public override var intrinsicContentSize: CGSize {
        Layout.size.outset(by: content.insets)
    }

    public init(content: ProgressActivityIndicator) {
        self.content = content

        super.init(frame: .zero)

        setupActivityIndicatorView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupActivityIndicatorView() {
        addSubview(activityIndicatorView)

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        activityIndicatorView.transform = CGAffineTransform(
            scaleX: max(Layout.size.width / activityIndicatorView.intrinsicContentSize.width, 1.0),
            y: max(Layout.size.height / activityIndicatorView.intrinsicContentSize.height, 1.0)
        )

        activityIndicatorView.color = content.color

        activityIndicatorView.startAnimating()

        let constraints = [
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
#endif
