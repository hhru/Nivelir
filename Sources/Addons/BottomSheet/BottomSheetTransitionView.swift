#if canImport(UIKit)
import UIKit

internal final class BottomSheetTransitionView: UIView {

    private let containerView = UIView()
    private let cardShadowView = UIView()
    private let cardView = UIView()
    private let grabberView = UIView()

    internal private(set) weak var contentView: UIView?

    internal var card: BottomSheetCard? {
        didSet {
            if card != oldValue {
                updateCardShadowView()
                updateCardView()
                setNeedsLayout()
            }
        }
    }

    internal var grabber: BottomSheetGrabber? {
        didSet {
            if grabber != oldValue {
                updateGrabberView()
                setNeedsLayout()
            }
        }
    }

    internal var contentInsets: UIEdgeInsets = .zero {
        didSet {
            if contentInsets != oldValue {
                setNeedsLayout()
            }
        }
    }

    internal init(contentView: UIView, frame: CGRect = .zero) {
        self.contentView = contentView

        super.init(frame: frame)

        setupContainerView()
        setupCardShadowView()
        setupCardView()
        setupContentView()
        setupGrabberView()
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func resolveCardMaskedCorners() -> CACornerMask {
        if contentInsets.bottom > .leastNonzeroMagnitude {
            return .allCorners
        }

        return [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
    }

    private func layoutContainerView() {
        containerView.frame = bounds.inset(by: contentInsets)
    }

    private func setupContainerView() {
        addSubview(containerView)

        containerView.clipsToBounds = false
    }

    private func updateCardShadowView() {
        let shadow = card?.shadow ?? .default

        cardShadowView.layer.shadowOffset = shadow.offset
        cardShadowView.layer.shadowRadius = shadow.radius
        cardShadowView.layer.shadowColor = shadow.color?.cgColor
        cardShadowView.layer.shadowOpacity = shadow.opacity
        cardShadowView.layer.shouldRasterize = shadow.shouldRasterize
    }

    private func layoutCardShadowView() {
        let topInset = grabber.map { grabber in
            -min(grabber.inset, .zero)
        } ?? .zero

        let frame = CGRect(
            x: containerView.bounds.minX,
            y: containerView.bounds.minY + topInset,
            width: containerView.bounds.width,
            height: containerView.bounds.height - topInset
        )

        cardShadowView.frame = frame

        let cornerRadius = card?.cornerRadius ?? .zero
        let maskedCorners = resolveCardMaskedCorners()

        cardShadowView.layer.shadowPath = UIBezierPath(
            roundedRect: cardShadowView.layer.bounds,
            byRoundingCorners: maskedCorners.rectCorners,
            cornerRadii: CGSize(
                width: cornerRadius,
                height: cornerRadius
            )
        ).cgPath
    }

    private func setupCardShadowView() {
        containerView.addSubview(cardShadowView)

        cardShadowView.isUserInteractionEnabled = false
        cardShadowView.clipsToBounds = false

        updateCardShadowView()
    }

    private func updateCardView() {
        cardView.backgroundColor = card?.backgroundColor
        cardView.layer.cornerRadius = card?.cornerRadius ?? .zero

        let border = card?.border ?? .default

        cardView.layer.borderWidth = border.width
        cardView.layer.borderColor = border.color?.cgColor
    }

    private func layoutCardView() {
        cardView.frame = cardShadowView.frame

        cardView.layer.maskedCorners = resolveCardMaskedCorners()
    }

    private func setupCardView() {
        containerView.addSubview(cardView)

        cardView.clipsToBounds = true

        updateCardView()
    }

    private func layoutContentView() {
        guard let contentView else {
            return
        }

        contentView.frame = cardView
            .bounds
            .inset(by: card?.contentInsets ?? .zero)

        contentView.layoutIfNeeded()
    }

    private func setupContentView() {
        guard let contentView else {
            return
        }

        cardView.addSubview(contentView)
    }

    private func updateGrabberView() {
        grabberView.alpha = grabber == nil ? .zero : 1.0
        grabberView.backgroundColor = grabber?.color
    }

    private func layoutGrabberView() {
        guard let grabber else {
            return
        }

        let size = grabber.size
        let inset = grabber.inset

        grabberView.frame = CGRect(
            x: containerView.bounds.midX - size.width * 0.5,
            y: cardView.frame.minY + inset,
            width: size.width,
            height: size.height
        )

        grabberView.layer.cornerRadius = 0.5 * min(size.width, size.height)
    }

    private func setupGrabberView() {
        containerView.addSubview(grabberView)

        grabberView.isUserInteractionEnabled = false
        grabberView.clipsToBounds = true

        updateGrabberView()
    }

    internal override func layoutSubviews() {
        super.layoutSubviews()

        layoutContainerView()
        layoutCardShadowView()
        layoutCardView()
        layoutContentView()
        layoutGrabberView()
    }

    internal override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let point = layer
            .presentation()?
            .convert(point, from: layer) ?? point

        return subviews.contains { subview in
            subview.point(
                inside: convert(point, to: subview),
                with: event
            )
        }
    }
}
#endif
