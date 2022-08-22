#if canImport(UIKit)
import UIKit

/// A view showing the text below the progress indicator.
public final class ProgressMessageFooterView: UIView, ProgressContentView {

    private enum Layout {
        static let maxWidth = 180.0
    }

    private let label = UILabel()

    public let content: ProgressMessageFooter

    public init(content: ProgressMessageFooter) {
        self.content = content

        super.init(frame: .zero)

        setupLabel()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = content.text
        label.font = content.font
        label.textColor = content.color
        label.textAlignment = content.alignment

        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let constraints = [
            label.topAnchor.constraint(
                equalTo: topAnchor,
                constant: content.insets.top
            ),
            label.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: content.insets.left
            ),
            label.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -content.insets.right
            ),
            label.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -content.insets.bottom
            ),
            label.widthAnchor.constraint(lessThanOrEqualToConstant: Layout.maxWidth)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
#endif
