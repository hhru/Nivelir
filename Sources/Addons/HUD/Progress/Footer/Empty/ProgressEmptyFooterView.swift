#if canImport(UIKit)
import UIKit

/// Empty view for the progress footer.
public final class ProgressEmptyFooterView: UIView, ProgressContentView {

    public let content: ProgressEmptyFooter

    public init(content: ProgressEmptyFooter) {
        self.content = content

        super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
