import UIKit

final class HomeTabBarItem: UITabBarItem {

    init(title: String, image: UIImage, tag: Int) {
        super.init()

        self.title = title
        self.image = image
        self.tag = tag

        titlePositionAdjustment = UIOffset(
            horizontal: 0,
            vertical: -2
        )

        imageInsets = UIEdgeInsets(
            top: -1,
            left: 0,
            bottom: 1,
            right: 0
        )

        badgeColor = Colors.important

        setTitleTextAttributes(
            [
                .font: UIFont.systemFont(ofSize: 10, weight: .medium),
                .kern: NSNumber(value: -0.24)
            ],
            for: .normal
        )
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITabBarItem {

    static let rooms = HomeTabBarItem(
        title: "Rooms",
        image: Images.roomsTab,
        tag: 1
    )

    static let profile = HomeTabBarItem(
        title: "Profile",
        image: Images.profileTab,
        tag: 2
    )

    static let moreExampleList = HomeTabBarItem(
        title: "More",
        image: Images.moreTab,
        tag: 3
    )
}
