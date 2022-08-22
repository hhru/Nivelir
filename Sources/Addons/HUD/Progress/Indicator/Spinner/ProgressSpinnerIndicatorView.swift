#if canImport(UIKit)
import UIKit

/// A view showing the spinner in the progress indicator.
public final class ProgressSpinnerIndicatorView: UIView, ProgressContentView {

    private enum Layout {
        static let size = CGSize(equilateral: 48.0)
    }

    private let shapeLayer = CAShapeLayer()

    public let content: ProgressSpinnerIndicator

    public override var intrinsicContentSize: CGSize {
        Layout.size.outset(by: content.insets)
    }

    public init(content: ProgressSpinnerIndicator) {
        self.content = content

        super.init(frame: .zero)

        setupShapeLayer()
        animateShapeLayer()
        paintShapeLayer()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 3

        layer.addSublayer(shapeLayer)
    }

    private func animateShapeLayer() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

        rotationAnimation.byValue = Float.pi * 2.0
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")

        strokeStartAnimation.duration = 1.2
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeStartAnimation.fromValue = 0.0
        strokeStartAnimation.toValue = 1.0
        strokeStartAnimation.beginTime = 0.5

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")

        strokeEndAnimation.duration = 0.7
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0

        let animation = CAAnimationGroup()

        animation.animations = [
            rotationAnimation,
            strokeEndAnimation,
            strokeStartAnimation
        ]

        animation.duration = strokeStartAnimation.beginTime + strokeStartAnimation.duration
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards

        shapeLayer.add(animation, forKey: "animation")
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

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        paintShapeLayer()
        setNeedsDisplay()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        layoutShapeLayer()
    }
}
#endif
