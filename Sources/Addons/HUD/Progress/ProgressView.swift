#if canImport(UIKit)
import UIKit

public final class ProgressView: UIView {

    private let headerContainerView = UIView()
    private let indicatorContainerView = UIView()
    private let footerContainerView = UIView()

    private var headerView: UIView?
    private var indicatorView: UIView?
    private var footerView: UIView?

    public var progress: Progress? {
        didSet { updateViews() }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupHeaderContainerView()
        setupIndicatorContainerView()
        setupFooterContainerView()

        clipsToBounds = true
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHeaderContainerView() {
        addSubview(headerContainerView)

        headerContainerView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            headerContainerView.topAnchor.constraint(equalTo: topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupIndicatorContainerView() {
        addSubview(indicatorContainerView)

        indicatorContainerView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            indicatorContainerView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            indicatorContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicatorContainerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupFooterContainerView() {
        addSubview(footerContainerView)

        footerContainerView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            footerContainerView.topAnchor.constraint(equalTo: indicatorContainerView.bottomAnchor),
            footerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Content

    private func setupContentView(
        _ contentView: UIView,
        containerView: UIView
    ) {
        containerView.insertSubview(contentView, at: .zero)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            contentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
        containerView.layoutIfNeeded()
    }

    private func animateContentView(
        _ contentView: UIView,
        previousContentView: UIView?,
        containerView: UIView,
        animation: ProgressAnimation?
    ) {
        guard let previousContentView = previousContentView else {
            return
        }

        guard let animation = animation, window != nil else {
            return previousContentView.removeFromSuperview()
        }

        animation.animateView(
            contentView,
            previousView: previousContentView,
            containerView: containerView
        )
    }

    private func updateContentView(
        _ previousContentView: UIView?,
        containerView: UIView,
        content: AnyProgressContent,
        animation: ProgressAnimation?
    ) -> UIView {
        let contentView = content.updateContentViewIfPossible(previousContentView)

        if contentView === previousContentView {
            return contentView
        }

        setupContentView(
            contentView,
            containerView: containerView
        )

        animateContentView(
            contentView,
            previousContentView: previousContentView,
            containerView: containerView,
            animation: animation
        )

        return contentView
    }

    private func removeViews() {
        headerView?.removeFromSuperview()
        indicatorView?.removeFromSuperview()
        footerView?.removeFromSuperview()

        headerView = nil
        indicatorView = nil
        footerView = nil
    }

    private func updateViews() {
        guard let progress = progress else {
            return removeViews()
        }

        headerView = updateContentView(
            headerView,
            containerView: headerContainerView,
            content: progress.header,
            animation: progress.animation
        )

        indicatorView = updateContentView(
            indicatorView,
            containerView: indicatorContainerView,
            content: progress.indicator,
            animation: progress.animation
        )

        footerView = updateContentView(
            footerView,
            containerView: footerContainerView,
            content: progress.footer,
            animation: progress.animation
        )
    }
}
#endif
