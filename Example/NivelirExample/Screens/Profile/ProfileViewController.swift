import UIKit
import SnapKit
import Nivelir

final class ProfileViewController: UIViewController, ScreenKeyedContainer {

    let authorizationService: AuthorizationService
    let profileService: ProfileService
    let screens: Screens
    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    private weak var profileUnauthorizedView: UIView?

    private var profileView: ProfileView? {
        viewIfLoaded as? ProfileView
    }

    init(
        authorizationService: AuthorizationService,
        profileService: ProfileService,
        screens: Screens,
        screenKey: ScreenKey,
        screenNavigator: ScreenNavigator
    ) {
        self.authorizationService = authorizationService
        self.profileService = profileService
        self.screens = screens
        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if os(iOS)
    @objc private func shareNivelirLink(sender: UIBarButtonItem) {
        let sharing = Sharing(
            items: [.nivelirLink],
            applicationActivities: [.openInBrowser],
            anchor: .barButtonItem(sender)
        )

        screenNavigator.navigate(from: self) { route in
            route.share(sharing)
        }
    }

    private func pickPhotoImageFromCamera() {
        let mediaPicker = MediaPicker(source: .camera) { result in
            self.screenNavigator.navigate(from: self) { route in
                route.dismiss()
            }

            if let image = result?.editedImage ?? result?.originalImage {
                self.uploadPhoto(image: image)
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
            self.screenNavigator.navigate(from: self) { route in
                route.dismiss()
            }

            if let image = result?.editedImage ?? result?.originalImage {
                self.uploadPhoto(image: image)
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

    private func uploadPhoto(image: UIImage) {
        profileService.uploadPhoto(
            image: image,
            progress: { ratio in
                self.screenNavigator.navigate { route in
                    route.showHUD(.percentage(ratio: ratio))
                }
            },
            completion: { result in
                switch result {
                case .success:
                    self.profileView?.photoImage = image

                    self.screenNavigator.navigate { route in
                        route.showHUD(.success, duration: 1.0)
                    }

                case .failure:
                    self.screenNavigator.navigate { route in
                        route.showHUD(.failure, duration: 1.0)
                    }
                }
            }
        )
    }

    private func showAuthorization() {
        screenNavigator.navigate(to: screens.showAuthorizationRoute())
    }

    private func setupProfileUnauthorizedView() {
        let profileUnauthorizedView = ProfileUnauthorizedView()

        profileUnauthorizedView.onLoginTapped = { [unowned self] in
            self.showAuthorization()
        }

        profileView?.addSubview(profileUnauthorizedView)

        profileUnauthorizedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.profileUnauthorizedView = profileUnauthorizedView
    }

    private func setupProfileView() {
        profileView?.onPhotoTapped = { [unowned self] sender in
            self.pickPhotoImage(sender: sender)
        }

        profileView?.onLogoutTapped = { [unowned self] in
            self.authorizationService.logout()
            self.profileUnauthorizedView?.isHidden = false
        }
    }

    #if os(iOS)
    private func setupShareBarButton() {
        let rightBarButtonItem = UIBarButtonItem(
            image: Images.share,
            style: .plain,
            target: self,
            action: #selector(shareNivelirLink(sender:))
        )

        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    #endif

    override func loadView() {
        view = ProfileView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        screenNavigator.observeWeakly(
            by: self,
            where: .satisfiedAll(
                .type(AuthorizationObserver.self),
                .satisfiedAny(
                    .presented(on: self),
                    .pushed(after: self),
                    .child(of: self),
                    .visible(self)
                )
            )
        )

        setupProfileView()
        setupProfileUnauthorizedView()

        #if os(iOS)
        setupShareBarButton()
        #endif
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        profileUnauthorizedView?.isHidden = authorizationService.isAuthorized
    }
}

extension ProfileViewController: AuthorizationObserver {

    func authorizationFinished(isAuthorized: Bool) {
        profileUnauthorizedView?.isHidden = isAuthorized
    }
}
