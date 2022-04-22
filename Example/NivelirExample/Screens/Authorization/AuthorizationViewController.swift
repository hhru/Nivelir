import UIKit
import Nivelir

final class AuthorizationViewController: UIViewController, ScreenKeyedContainer {

    let authorizationService: AuthorizationService
    let screenObserver: ScreenObserver<AuthorizationObserver>
    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    private var authorizationView: AuthorizationView? {
        viewIfLoaded as? AuthorizationView
    }

    init(
        authorizationService: AuthorizationService,
        screenObserver: ScreenObserver<AuthorizationObserver>,
        screenKey: ScreenKey,
        screenNavigator: ScreenNavigator
    ) {
        self.authorizationService = authorizationService
        self.screenObserver = screenObserver
        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)

        title = "Authorization"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onCloseBarBattonTouchUpInside() {
        screenNavigator.navigate(
            from: presenting,
            to: { route in
                route.dismiss()
            },
            completion: { _ in
                self.screenObserver.post { observer in
                    observer.didFinishAuthorization(isAuthorized: false)
                }
            }
        )
    }

    private func setupCloseBarButton() {
        let closeBarBattonItem = UIBarButtonItem(
            image: Images.close,
            style: .plain,
            target: self,
            action: #selector(onCloseBarBattonTouchUpInside)
        )

        closeBarBattonItem.tintColor = Colors.important

        navigationItem.leftBarButtonItem = closeBarBattonItem
    }

    private func setupAuthorizationView() {
        authorizationView?.onLoginTapped = { [weak self] phoneNumber in
            guard let self = self else {
                return
            }

            self.authorizationService.login(phoneNumber: phoneNumber)

            self.screenNavigator.navigate(
                from: self.presenting,
                to: { $0.dismiss() },
                completion: { _ in
                    self.screenObserver.post { observer in
                        observer.didFinishAuthorization(isAuthorized: true)
                    }
                }
            )
        }
    }

    override func loadView() {
        view = AuthorizationView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.presentationController?.delegate = self

        setupCloseBarButton()
        setupAuthorizationView()
    }
}

extension AuthorizationViewController: UIAdaptivePresentationControllerDelegate {

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        screenObserver.post { observer in
            observer.didFinishAuthorization(isAuthorized: false)
        }
    }
}
