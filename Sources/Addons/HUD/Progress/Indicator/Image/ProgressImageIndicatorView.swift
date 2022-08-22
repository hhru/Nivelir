#if canImport(UIKit)
import UIKit

/// A view showing the image in the progress indicator.
public final class ProgressImageIndicatorView: UIView, ProgressContentView {

    private enum Layout {
        static let size = CGSize(equilateral: 48.0)
    }

    private let imageView = UIImageView()

    public let content: ProgressImageIndicator

    public override var intrinsicContentSize: CGSize {
        Layout.size.outset(by: content.insets)
    }

    public init(content: ProgressImageIndicator) {
        self.content = content

        super.init(frame: .zero)

        setupImageView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageView() {
        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = content.image

        let constraints = [
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Layout.size.width),
            imageView.heightAnchor.constraint(equalToConstant: Layout.size.height)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
#endif
