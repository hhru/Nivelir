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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if os(iOS)
    private func pickPhotoImageFromCamera() {
        let mediaPicker = MediaPicker(source: .camera) { result in
            self.screenNavigator.navigate(from: self) { $0.dismiss() }

            if let result = result {
                self.profileView.photoImage = result.editedImage ?? result.originalImage
            }
        }

        screenNavigator.navigate(from: self) { route in
            route
                .showMediaPicker(mediaPicker)
                .fallback { error, route in
                    switch error {
                    case is MediaPickerSourceAccessDeniedError:
                        return route.showAlert(.cameraPermissionRequired)

                    case is UnavailableMediaPickerSourceError:
                        return route.showAlert(.unavailableMediaSource)

                    case is UnavailableMediaPickerTypesError:
                        return route.showAlert(.unavailableMediaTypes)

                    default:
                        return route.showAlert(.somethingWentWrong)
                    }
                }
        }
    }

    private func pickPhotoImageFromPhotoLibrary() {
        let mediaPicker = MediaPicker { result in
            self.screenNavigator.navigate(from: self) { $0.dismiss() }

            if let result = result {
                self.profileView.photoImage = result.editedImage ?? result.originalImage
            }
        }

        screenNavigator.navigate(from: self) { route in
            route
                .showMediaPicker(mediaPicker)
                .fallback { error, route in
                    switch error {
                    case is MediaPickerSourceAccessDeniedError:
                        return route.showAlert(.photoLibraryPermissionRequired)

                    case is UnavailableMediaPickerSourceError:
                        return route.showAlert(.unavailableMediaSource)

                    case is UnavailableMediaPickerTypesError:
                        return route.showAlert(.unavailableMediaTypes)

                    default:
                        return route
                    }
                }
        }
    }

    private func pickPhotoImage(sender: UIView) {
        let actionSheet = ActionSheet(
            anchor: .center(of: sender),
            actions: [
                ActionSheetAction(title: "Take Photo") {
                    self.pickPhotoImageFromCamera()
                },
                ActionSheetAction(title: "Choose Photo") {
                    self.pickPhotoImageFromPhotoLibrary()
                },
                .cancel(title: "Cancel")
            ]
        )

        screenNavigator.navigate(from: self) { route in
            route.showActionSheet(actionSheet)
        }
    }
    #else
    private func pickPhotoImage(sender: UIView) { }
    #endif

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

extension Alert {

    static let somethingWentWrong = Self(
        title: "Error",
        message: """
            Something went wrong.
            """,
        actions: AlertAction(title: "OK")
    )

    static let unavailableMediaTypes = Self(
        title: "Error",
        message: """
            Your device does not support the required media types.
            """,
        actions: AlertAction(title: "OK")
    )

    static let unavailableMediaSource = Self(
        title: "Error",
        message: """
            Your device does not support the selected media source.
            """,
        actions: AlertAction(title: "OK")
    )

    static let photoLibraryPermissionRequired = Self(
        title: "Permission Required",
        message: """
            The app needs permission to access your photo library to select a photo. \
            Please go to Setting > Privacy > Photos and enable Nivelir Example.
            """,
        actions: [
            AlertAction(title: "Not Now"),
            AlertAction(title: "Open Settings") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        ]
    )

    static let cameraPermissionRequired = Self(
        title: "Permission Required",
        message: """
            The app needs permission to access your device's camera to take a photo. \
            Please go to Setting > Privacy > Camera, and enable Nivelir Example.
            """,
        actions: [
            AlertAction(title: "Not Now"),
            AlertAction(title: "Open Settings") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        ]
    )
}
