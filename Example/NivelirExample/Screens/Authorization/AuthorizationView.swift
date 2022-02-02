import UIKit

final class AuthorizationView: UIView {

    private let messageLabel = UILabel()
    private let phoneNumberTextField = UITextField()
    private let loginButton = UIButton(type: .system)

    var onLoginTapped: ((_ phoneNumber: String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Colors.background

        setupMessageLabel()
        setupPhoneNumberTextField()
        setupLoginButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onLoginButtonTouchUpInside() {
        onLoginTapped?(phoneNumberTextField.text ?? "")
    }

    private func setupMessageLabel() {
        addSubview(messageLabel)

        messageLabel.text = "Enter your phone number\nto log in"
        messageLabel.textColor = Colors.title.withAlphaComponent(0.3)
        messageLabel.font = .systemFont(ofSize: 16.0)
        messageLabel.numberOfLines = 0

        messageLabel.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeAreaLayoutGuide).inset(16.0)
        }
    }

    private func setupPhoneNumberTextField() {
        addSubview(phoneNumberTextField)

        phoneNumberTextField.text = "+7"
        phoneNumberTextField.textColor = Colors.title
        phoneNumberTextField.tintColor = Colors.important
        phoneNumberTextField.font = .systemFont(ofSize: 24.0)
        phoneNumberTextField.borderStyle = .none
        phoneNumberTextField.textContentType = .telephoneNumber
        phoneNumberTextField.returnKeyType = .done
        phoneNumberTextField.delegate = self

        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(32.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
    }

    private func setupLoginButton() {
        addSubview(loginButton)

        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(Colors.important, for: .normal)

        loginButton.titleLabel?.font = .systemFont(ofSize: 15.0)

        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        loginButton.layer.borderColor = Colors.important.cgColor
        loginButton.layer.borderWidth = 1.0

        loginButton.addTarget(
            self,
            action: #selector(onLoginButtonTouchUpInside),
            for: .touchUpInside
        )

        loginButton.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(safeAreaLayoutGuide).inset(24.0)
            make.height.equalTo(48.0)
        }
    }
}

extension AuthorizationView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
