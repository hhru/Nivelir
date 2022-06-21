#if canImport(UIKit)
import UIKit

public final class ProgressPercentageIndicatorView: UIView, ProgressContentView {

    private enum Layout {
        static let size = CGSize(equilateral: 48.0)
    }

    private var ratioLabel = UILabel()
    private let shapeLayer = CAShapeLayer()

    public var content: ProgressPercentageIndicator {
        didSet {
            updateRatioLabel(animated: window != nil)
            updateShapeLayer(animated: window != nil)
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    public override var intrinsicContentSize: CGSize {
        Layout.size.outset(by: content.insets)
    }

    public init(content: ProgressPercentageIndicator) {
        self.content = content

        super.init(frame: .zero)

        setupRatioLabel()
        setupShapeLayer()

        updateRatioLabel()
        updateShapeLayer()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupRatioLabel() {
        addSubview(ratioLabel)

        ratioLabel.translatesAutoresizingMaskIntoConstraints = false
        ratioLabel.font = .systemFont(ofSize: 11.0)
        ratioLabel.textAlignment = .center

        let constraints = [
            ratioLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ratioLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupShapeLayer() {
        let halfWidth = Layout.size.width * 0.5
        let halfHeight = Layout.size.height * 0.5

        let path = UIBezierPath(
            arcCenter: CGPoint(x: halfWidth, y: halfHeight),
            radius: halfWidth,
            startAngle: -0.5 * .pi,
            endAngle: 1.5 * .pi,
            clockwise: true
        )

        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3.0

        layer.addSublayer(shapeLayer)
    }

    private func paintShapeLayer() {
        shapeLayer.strokeColor = content.color.cgColor
    }

    private func layoutShapeLayer() {
        shapeLayer.frame = CGRect(
            x: (bounds.width - Layout.size.width) * 0.5,
            y: (bounds.height - Layout.size.height) * 0.5,
            width: Layout.size.width,
            height: Layout.size.height
        )
    }

    private func updateRatioLabel() {
        ratioLabel.text = "\(Int(content.resolveRatio() * 100.0))%"
        ratioLabel.textColor = content.color
    }

    private func updateRatioLabel(animated: Bool) {
        guard animated else {
            return updateRatioLabel()
        }

        UIView.transition(
            with: ratioLabel,
            duration: 0.25,
            options: .transitionCrossDissolve
        ) {
            self.updateRatioLabel()
        }
    }

    private func updateShapeLayer() {
        shapeLayer.strokeEnd = content.resolveRatio()

        paintShapeLayer()
    }

    private func updateShapeLayer(animated: Bool) {
        guard animated else {
            return updateShapeLayer()
        }

        let animation = CABasicAnimation(keyPath: "strokeEnd")

        animation.duration = 0.2
        animation.fromValue = shapeLayer.strokeEnd
        animation.toValue = content.resolveRatio()
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false

        updateShapeLayer()

        shapeLayer.removeAllAnimations()
        shapeLayer.add(animation, forKey: "animation")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        layoutShapeLayer()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setupShapeLayer()
        setNeedsDisplay()
    }
}

extension ProgressPercentageIndicator {

    internal func resolveRatio() -> CGFloat {
        max(min(ratio, 1.0), .zero)
    }
}
#endif
