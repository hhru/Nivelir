#if canImport(UIKit)
import UIKit

public enum AlertTextField {

    case standard(
        text: String,
        placeholder: String? = nil
    )

    case custom(configuration: (UITextField) -> Void)
}

extension AlertTextField {

    public static let standard = Self.standard(text: "")
}
#endif
