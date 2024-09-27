import UIKit
import Nivelir

final class AuthorizationViewController: UIViewController, ScreenKeyedContainer {

    let authorizationService: AuthorizationService
    let screenObservation: ScreenObservation<AuthorizationObserver>
    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    private var authorizationView: AuthorizationView? {
        viewIfLoaded as? AuthorizationView
    }

    init(
        authorizationService: AuthorizationService,
        screenObservation: ScreenObservation<AuthorizationObserver>,
        screenKey: ScreenKey,
        screenNavigator: ScreenNavigator
    ) {
        self.authorizationService = authorizationService
        self.screenObservation = screenObservation
        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)

        title = "Authorization"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onCloseBarButtonTouchUpInside() {
        screenNavigator.navigate(
            from: presenting,
            to: { route in
                route.dismiss()
            },
            completion: { _ in
                self.screenObservation { observer in
                    observer.authorizationFinished(isAuthorized: false)
                }
            }
        )
    }

    private func authorizeUser(phoneNumber: String) {
        screenNavigator.navigate { $0.showHUD(.spinner) }

        authorizationService.login(phoneNumber: phoneNumber) { [weak self] result in
            guard let self else {
                return
            }

            switch result {
            case .success:
                screenNavigator.navigate(
                    from: presenting,
                    to: { route in
                        route
                            .showHUD(.success, duration: 1.0)
                            .wait(for: 0.75)
                            .dismiss()
                    },
                    completion: { _ in
                        self.screenObservation { observer in
                            observer.authorizationFinished(isAuthorized: true)
                        }
                    }
                )

            case .failure:
                screenNavigator.navigate { route in
                    route.showHUD(.failure, duration: 1.0)
                }
            }
        }
    }

    private func setupCloseBarButton() {
        let closeBarBattonItem = UIBarButtonItem(
            image: Images.close,
            style: .plain,
            target: self,
            action: #selector(onCloseBarButtonTouchUpInside)
        )

        closeBarBattonItem.tintColor = Colors.important

        navigationItem.leftBarButtonItem = closeBarBattonItem
    }

    private func setupAuthorizationView() {
        authorizationView?.onLoginTapped = { [weak self] phoneNumber in
            self?.authorizeUser(phoneNumber: phoneNumber)
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
        screenObservation { observer in
            observer.authorizationFinished(isAuthorized: false)
        }
    }
}
