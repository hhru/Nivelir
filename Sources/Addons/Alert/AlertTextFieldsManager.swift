#if canImport(UIKit)
import UIKit

@MainActor
internal final class AlertTextFieldsManager: NSObject {

    private let textFields: [UITextField?]
    private let textsChanged: (_ texts: [String]) -> Void

    internal init(
        textFields: [UITextField?],
        textsChanged: @escaping (_ texts: [String]) -> Void
    ) {
        self.textFields = textFields
        self.textsChanged = textsChanged

        super.init()

        textFields.forEach { textField in
            textField?.addTarget(
                self,
                action: #selector(handleTextFieldEditingChanged),
                for: .editingChanged
            )
        }

        handleTextFieldEditingChanged()
    }

    @objc private func handleTextFieldEditingChanged() {
        textsChanged(textFields.map { $0?.text ?? "" })
    }
}
#endif
