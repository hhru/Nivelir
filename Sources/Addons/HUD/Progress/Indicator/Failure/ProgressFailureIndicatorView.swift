#if canImport(UIKit)
import UIKit

public final class ProgressFailureIndicatorView: UIView, ProgressContentView {

    private enum Layout {
        static let size = CGSize(equilateral: 40.0)
    }

    private let firstShapeLayer = CAShapeLayer()
    private let secondShapeLayer = CAShapeLayer()

    public let content: ProgressFailureIndicator

    public override var intrinsicContentSize: CGSize {
        Layout.size.outset(by: content.insets)
    }

    public init(content: ProgressFailureIndicator) {
        self.content = content

        super.init(frame: .zero)

        setupShapeLayers()
        animateShapeLayers()
        paintShapeLayers()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupShapeLayer(_ shapeLayer: CAShapeLayer, path: UIBezierPath) {
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 6.0
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.strokeEnd = 0.0

        layer.addSublayer(shapeLayer)
    }

    private func setupShapeLayers() {
        let firstPath = UIBezierPath()
        let secondPath = UIBezierPath()

        let length = Layout.size.width

        firstPath.move(to: CGPoint(x: length * 0.15, y: length * 0.15))
        secondPath.move(to: CGPoint(x: length * 0.15, y: length * 0.85))

        firstPath.addLine(to: CGPoint(x: length * 0.85, y: length * 0.85))
        secondPath.addLine(to: CGPoint(x: length * 0.85, y: length * 0.15))

        setupShapeLayer(firstShapeLayer, path: firstPath)
        setupShapeLayer(secondShapeLayer, path: secondPath)
    }

    private func animateShapeLayers() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        animation.duration = 0.25
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.beginTime = CACurrentMediaTime() + 0.15

        firstShapeLayer.add(animation, forKey: "animation")
        animation.beginTime += animation.duration
        secondShapeLayer.add(animation, forKey: "animation")
    }

    private func paintShapeLayer(_ shapeLayer: CAShapeLayer) {
        shapeLayer.strokeColor = content.color.cgColor
    }

    private func paintShapeLayers() {
        paintShapeLayer(firstShapeLayer)
        paintShapeLayer(secondShapeLayer)
    }

    private func layoutShapeLayer(_ shapeLayer: CAShapeLayer) {
        shapeLayer.frame = CGRect(
            x: (bounds.width - Layout.size.width) * 0.5,
            y: (bounds.height - Layout.size.height) * 0.5,
            width: Layout.size.width,
            height: Layout.size.height
        )
    }

    private func layoutShapeLayers() {
        layoutShapeLayer(firstShapeLayer)
        layoutShapeLayer(secondShapeLayer)
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        paintShapeLayers()
        setNeedsDisplay()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        layoutShapeLayers()
    }
}
#endif
