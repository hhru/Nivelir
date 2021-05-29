import UIKit

final class ChatEmptyView: UIView {

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        backgroundColor = Colors.background

        setupIconImageView()
        setupTitleLabel()
        setupSubtitleLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupIconImageView() {
        addSubview(iconImageView)

        iconImageView.image = Images.chat
        iconImageView.contentMode = .scaleAspectFit

        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70.0)
            make.size.equalTo(140.0)
        }
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)

        titleLabel.textColor = Colors.title
        titleLabel.font = .systemFont(ofSize: 24.0)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(16.0)
            make.centerX.equalToSuperview()
        }
    }

    private func setupSubtitleLabel() {
        addSubview(subtitleLabel)

        subtitleLabel.text = "No messages, yet!"
        subtitleLabel.textColor = Colors.unimportant
        subtitleLabel.font = .systemFont(ofSize: 16.0)

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            make.centerX.equalToSuperview()
        }
    }
}
