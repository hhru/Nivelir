import UIKit
import SnapKit

final class ProfileUnauthorizedView: UIView {

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let loginButton = UIButton()

    var onLoginTapped: (() -> Void)?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        backgroundColor = Colors.background

        setupIconImageView()
        setupTitleLabel()
        setupLoginButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onLoginButtonTouchUpInside() {
        onLoginTapped?()
    }

    private func setupIconImageView() {
        addSubview(iconImageView)

        iconImageView.image = Images.unauthorized
        iconImageView.tintColor = Colors.unimportant
        iconImageView.contentMode = .scaleAspectFit

        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70.0)
            make.size.equalTo(120.0)
        }
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)

        titleLabel.text = "Log in to your account"
        titleLabel.textColor = Colors.title
        titleLabel.font = .systemFont(ofSize: 24.0)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(16.0)
            make.centerX.equalToSuperview()
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
