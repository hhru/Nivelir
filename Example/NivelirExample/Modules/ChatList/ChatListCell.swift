import UIKit
import SnapKit

final class ChatListCell: UITableViewCell, Reusable {

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    var title: String {
        get { titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }

    var subtitle: String {
        get { subtitleLabel.text ?? "" }
        set { subtitleLabel.text = newValue }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = Colors.background

        setupIconImageView()
        setupTitleLabel()
        setupSubtitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupIconImageView() {
        contentView.addSubview(iconImageView)

        iconImageView.image = Images.chat
        iconImageView.contentMode = .scaleAspectFit

        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(32.0)
        }
    }

    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)

        titleLabel.textColor = Colors.title
        titleLabel.font = .systemFont(ofSize: 16.0)

        titleLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(16.0)
            make.left.equalTo(iconImageView.snp.right).offset(16.0)
        }
    }

    private func setupSubtitleLabel() {
        contentView.addSubview(subtitleLabel)

        subtitleLabel.textColor = Colors.unimportant
        subtitleLabel.font = UIFont.systemFont(ofSize: 14.0)

        subtitleLabel.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(16.0)
            make.left.equalTo(iconImageView.snp.right).offset(16.0)
        }
    }
}
