import UIKit
import SnapKit

final class ProfileView: UIView {

    private let photoButton = UIButton()
    private let nameLabel = UILabel()
    private let companyLabel = UILabel()
    private let logoutButton = UIButton()

    var photoImage: UIImage? {
        get { photoButton.imageView?.image }
        set { photoButton.setImage(newValue, for: .normal) }
    }

    var onPhotoTapped: ((_ sender: UIView ) -> Void)?
    var onLogoutTapped: (() -> Void)?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        backgroundColor = Colors.background

        setupPhotoButton()
        setupNameLabel()
        setupCompanyLabel()
        setupLogoutButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onPhotoButtonTouchUpInside() {
        onPhotoTapped?(photoButton)
    }

    @objc private func onLogoutButtonTouchUpInside() {
        onLogoutTapped?()
    }

    private func setupPhotoButton() {
        addSubview(photoButton)

        photoButton.setImage(Images.user, for: .normal)
        photoButton.imageView?.contentMode = .scaleAspectFill

        photoButton.clipsToBounds = true
        photoButton.layer.cornerRadius = 60.0

        photoButton.addTarget(
            self,
            action: #selector(onPhotoButtonTouchUpInside),
            for: .touchUpInside
        )

        photoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70.0)
            make.size.equalTo(120.0)
        }
    }

    private func setupNameLabel() {
        addSubview(nameLabel)

        nameLabel.text = "Rick Sanchez"
        nameLabel.textColor = Colors.title
        nameLabel.font = .systemFont(ofSize: 24.0)

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoButton.snp.bottom).offset(16.0)
            make.centerX.equalToSuperview()
        }
    }

    private func setupCompanyLabel() {
        addSubview(companyLabel)

        companyLabel.text = "C-137"
        companyLabel.textColor = Colors.unimportant
        companyLabel.font = .systemFont(ofSize: 16.0)

        companyLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4.0)
            make.centerX.equalToSuperview()
        }
    }

    private func setupLogoutButton() {
        addSubview(logoutButton)

        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(Colors.important, for: .normal)

        logoutButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)

        logoutButton.layer.cornerRadius = 8.0
        logoutButton.layer.masksToBounds = true
        logoutButton.layer.borderColor = Colors.important.cgColor
        logoutButton.layer.borderWidth = 1.0

        logoutButton.addTarget(
            self,
            action: #selector(onLogoutButtonTouchUpInside),
            for: .touchUpInside
        )

        logoutButton.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(safeAreaLayoutGuide).inset(24.0)
            make.height.equalTo(48.0)
        }
    }
}
