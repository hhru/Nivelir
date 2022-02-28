import UIKit

final class MoreExampleListCell: UITableViewCell, Reusable {

    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()

    var title: String {
        get { titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = Colors.background

        setupTitleLabel()
        setupChevronImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)

        titleLabel.textColor = Colors.title
        titleLabel.font = .systemFont(ofSize: 16.0)

        titleLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(16.0)
        }
    }

    private func setupChevronImageView() {
        contentView.addSubview(chevronImageView)

        chevronImageView.image = Images.chevron
        chevronImageView.tintColor = Colors.icon
        chevronImageView.contentMode = .scaleAspectFit

        chevronImageView.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(8.0)
            make.right.equalToSuperview().inset(16.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 8.0, height: 14.0))
        }
    }
}
