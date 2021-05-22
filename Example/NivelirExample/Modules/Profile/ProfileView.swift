import UIKit

final class ProfileView: UIView {

    private let photoButton = UIButton()
    private let nameLabel = UILabel()
    private let companyLabel = UILabel()

    var photoImage: UIImage? {
        get { photoButton.imageView?.image }
        set { photoButton.setImage(newValue, for: .normal) }
    }

    var onPhotoTapped: (() -> Void)?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        backgroundColor = Colors.background

        setupPhotoButton()
        setupNameLabel()
        setupCompanyLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onPhotoButtonTouchUpInside() {
        onPhotoTapped?()
    }

    private func setupPhotoButton() {
        addSubview(photoButton)

        photoButton.setImage(Images.user, for: .normal)
        photoButton.imageView?.contentMode = .scaleAspectFill

        photoButton.clipsToBounds = true
        photoButton.layer.cornerRadius = 70.0

        photoButton.addTarget(
            self,
            action: #selector(onPhotoButtonTouchUpInside),
            for: .touchUpInside
        )

        photoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70.0)
            make.size.equalTo(140.0)
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
}
