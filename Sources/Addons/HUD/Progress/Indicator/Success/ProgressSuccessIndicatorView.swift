#if canImport(UIKit)
import UIKit

public final class ProgressSuccessIndicatorView: UIView, ProgressContentView {

    private enum Layout {
        static let size = CGSize(equilateral: 40.0)
    }

    private let shapeLayer = CAShapeLayer()

    public let content: ProgressSuccessIndicator

    public override var intrinsicContentSize: CGSize {
        Layout.size.outset(by: content.insets)
    }

    public init(content: ProgressSuccessIndicator) {
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
        let length = Layout.size.width
        let path = UIBezierPath()

        path.move(to: CGPoint(x: length * 0.15, y: length * 0.50))
        path.addLine(to: CGPoint(x: length * 0.5, y: length * 0.80))
        path.addLine(to: CGPoint(x: length * 1.0, y: length * 0.25))

        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 6.0
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.strokeEnd = 0.0

        layer.addSublayer(shapeLayer)
    }

    private func animateShapeLayer() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        animation.duration = 0.25
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.beginTime = CACurrentMediaTime() + 0.15

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
