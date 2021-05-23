import UIKit
import Nivelir

final class ProfileViewController: UIViewController, ScreenKeyedContainer {

    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    private var profileView: ProfileView {
        view as! ProfileView
    }

    init(screenKey: ScreenKey, screenNavigator: ScreenNavigator) {
        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func pickPhotoImage(sender: UIView) { }

    override func loadView() {
        view = ProfileView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profileView.onPhotoTapped = { [unowned self] sender in
            self.pickPhotoImage(sender: sender)
        }
    }
}
