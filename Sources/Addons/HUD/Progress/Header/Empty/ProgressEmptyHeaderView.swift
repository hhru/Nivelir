#if canImport(UIKit)
import UIKit

public final class ProgressEmptyHeaderView: UIView, ProgressContentView {

    public var content: ProgressEmptyHeader

    public init(content: ProgressEmptyHeader) {
        self.content = content

        super.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
