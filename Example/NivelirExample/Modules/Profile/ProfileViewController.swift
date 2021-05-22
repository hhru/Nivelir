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

    private func pickPhotoImage() { }

    override func loadView() {
        view = ProfileView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profileView.onPhotoTapped = { [unowned self] in
            self.pickPhotoImage()
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let photoImage = (info[.editedImage] ?? info[.originalImage]) as? UIImage else {
            return
        }

        profileView.photoImage = photoImage

        screenNavigator.navigate(from: picker) { route in
            route.presenting.dismiss()
        }
    }
}
