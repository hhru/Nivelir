import UIKit
import Nivelir

final class WhatsNewViewController: UIViewController, ScreenKeyedContainer {

    private let scrollView = UIScrollView()

    private let exampleTextView = UITextView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let actionsView = UIView()
    private let moreButton = UIButton()
    private let closeButton = UIButton()

    let screens: Screens
    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    init(
        screens: Screens,
        screenKey: ScreenKey,
        screenNavigator: ScreenNavigator
    ) {
        self.screens = screens
        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)

        self.title = "What's New"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onMoreButtonTouchUpInside() {
        screenNavigator.navigate(from: stack) { route in
            #if os(iOS)
                route.push(screens.whatsNewMoreScreen())
            #else
                route.push(screens.whatsNewScreen())
            #endif
        }
    }

    @objc private func onCloseButtonTouchUpInside() {
        screenNavigator.navigate(from: presenting) { route in
            route.dismiss()
        }
    }

    private func setupScrollView() {
        view.addSubview(scrollView)

        scrollView.contentInset = UIEdgeInsets(
            top: scrollView.contentInset.top,
            left: scrollView.contentInset.left,
            bottom: 128.0,
            right: scrollView.contentInset.right
        )

        scrollView.alwaysBounceVertical = true

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.contentLayoutGuide)
        }
    }

    private func setupExampleTextView() {
        scrollView.addSubview(exampleTextView)

        exampleTextView.text = """
            let bottomSheet = BottomSheet(
                detents: [.large, .content],
                preferredGrabber: .default,
                prefferedGrabberForMaximumDetentValue: .default
            )

            screenNavigator.navigate(from: self) { route in
                route.present(
                    screens
                        .whatsNewScreen()
                        .withBottomSheetStack(bottomSheet)
                )
            }
            """

        exampleTextView.textColor = Colors.title
        exampleTextView.font = .monospacedSystemFont(ofSize: 10.0, weight: .regular)

        exampleTextView.contentInset = UIEdgeInsets(top: 4.0, left: 2.0, bottom: 4.0, right: 2.0)

        exampleTextView.layer.cornerRadius = 8.0
        exampleTextView.layer.masksToBounds = true
        exampleTextView.layer.borderColor = Colors.unimportant.cgColor
        exampleTextView.layer.borderWidth = 1.0

        exampleTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(140)
        }
    }

    private func setupTitleLabel() {
        scrollView.addSubview(titleLabel)

        titleLabel.text = "Bottom sheets"
        titleLabel.textAlignment = .center
        titleLabel.textColor = Colors.title
        titleLabel.font = .boldSystemFont(ofSize: 24.0)
        titleLabel.numberOfLines = .zero

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(exampleTextView.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(16)
        }
    }

    private func setupDescriptionLabel() {
        scrollView.addSubview(descriptionLabel)

        descriptionLabel.text = """
            Bottom sheet is an implementation of custom modal presentation style \
            for thumb-friendly interactive views anchored to the bottom of the screen.
            """

        descriptionLabel.textColor = Colors.title
        descriptionLabel.font = .systemFont(ofSize: 14.0)
        descriptionLabel.numberOfLines = .zero

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    private func setupActionsView() {
        view.addSubview(actionsView)

        actionsView.backgroundColor = Colors.background

        actionsView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func setupMoreButton() {
        actionsView.addSubview(moreButton)

        moreButton.setTitle("More", for: .normal)
        moreButton.setTitleColor(Colors.important, for: .normal)

        moreButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)

        moreButton.layer.cornerRadius = 8.0
        moreButton.layer.masksToBounds = true
        moreButton.layer.borderColor = Colors.important.cgColor
        moreButton.layer.borderWidth = 1.0

        moreButton.addTarget(
            self,
            action: #selector(onMoreButtonTouchUpInside),
            for: .touchUpInside
        )

        moreButton.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }

    private func setupCloseButton() {
        actionsView.addSubview(closeButton)

        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(Colors.title, for: .normal)

        closeButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)

        closeButton.layer.cornerRadius = 8.0
        closeButton.layer.masksToBounds = true
        closeButton.layer.borderColor = Colors.title.cgColor
        closeButton.layer.borderWidth = 1.0

        closeButton.addTarget(
            self,
            action: #selector(onCloseButtonTouchUpInside),
            for: .touchUpInside
        )

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(moreButton.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
    }

    private func updatePreferredContentSize() {
        let insets = scrollView.contentInset

        let width = view.bounds.width

        let height = scrollView.contentSize.height
            + insets.top
            + insets.bottom

        let preferredContentSize = CGSize(
            width: width,
            height: height
        )

        if self.preferredContentSize != preferredContentSize {
            self.preferredContentSize = preferredContentSize
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        #if os(iOS)
        navigationItem.largeTitleDisplayMode = .never
        #endif

        view.backgroundColor = Colors.background

        setupScrollView()

        setupExampleTextView()
        setupTitleLabel()
        setupDescriptionLabel()

        setupActionsView()
        setupMoreButton()
        setupCloseButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updatePreferredContentSize()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updatePreferredContentSize()
    }
}
