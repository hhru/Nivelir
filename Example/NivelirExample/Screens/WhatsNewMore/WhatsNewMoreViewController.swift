import UIKit
import Nivelir

final class WhatsNewMoreViewController: UIViewController, ScreenKeyedContainer {

    private let scrollView = UIScrollView()

    private let selectedDetentLabel = UILabel()
    private let selectedDetentSegmentedControl = UISegmentedControl()

    private let contentHeightTitleLabel = UILabel()
    private let contentHeightValueLabel = UILabel()
    private let contentHeightStepper = UIStepper()

    private let scrollingExpandsHeightLabel = UILabel()
    private let scrollingExpandsHeightSwitch = UISwitch()

    private let canDismissLabel = UILabel()
    private let canDismissSwitch = UISwitch()

    private let actionsView = UIView()
    private let closeButton = UIButton()

    let screenKey: ScreenKey
    let screenNavigator: ScreenNavigator

    init(
        screenKey: ScreenKey,
        screenNavigator: ScreenNavigator
    ) {
        self.screenKey = screenKey
        self.screenNavigator = screenNavigator

        super.init(nibName: nil, bundle: nil)

        self.title = "Bottom sheet"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onSelectedDetentSegmentedControlValueChanged() {
        guard let bottomSheet else {
            return
        }

        let selectedDetentKey = bottomSheet
            .detents[selectedDetentSegmentedControl.selectedSegmentIndex]
            .key

        bottomSheet.animateChanges { bottomSheet in
            bottomSheet.selectedDetentKey = selectedDetentKey
        }
    }

    @objc private func onContentHeightStepperValueChanged() {
        updateContentHeightValueLabel()
        updatePreferredContentSize()
    }

    @objc private func onScrollingExpandsHeightSwitchValueChanged() {
        bottomSheet?.prefersScrollingExpandsHeight = scrollingExpandsHeightSwitch.isOn
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
            bottom: 76.0,
            right: scrollView.contentInset.right
        )

        scrollView.alwaysBounceVertical = true

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.contentLayoutGuide)
        }
    }

    private func setupSelectedDetentLabel() {
        scrollView.addSubview(selectedDetentLabel)

        selectedDetentLabel.text = "Selected detent:"
        selectedDetentLabel.textColor = Colors.title
        selectedDetentLabel.font = .boldSystemFont(ofSize: 16.0)

        selectedDetentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
        }
    }

    private func updateSelectedDetentSegmentedControl() {
        guard let bottomSheet else {
            return
        }

        let selectedSegmentIndex = bottomSheet
            .detents
            .enumerated()
            .first { $1.key == bottomSheet.selectedDetentKey }?
            .offset ?? .zero

        selectedDetentSegmentedControl.selectedSegmentIndex = selectedSegmentIndex
    }

    private func setupSelectedDetentSegmentedControl() {
        scrollView.addSubview(selectedDetentSegmentedControl)

        selectedDetentSegmentedControl.setTitleTextAttributes(
            [.font: UIFont.systemFont(ofSize: 16.0)],
            for: .normal
        )

        bottomSheet?.detents.enumerated().forEach { index, detent in
            selectedDetentSegmentedControl.insertSegment(
                withTitle: detent.key.rawValue.capitalized,
                at: index,
                animated: false
            )
        }

        selectedDetentSegmentedControl.addTarget(
            self,
            action: #selector(onSelectedDetentSegmentedControlValueChanged),
            for: .valueChanged
        )

        selectedDetentSegmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.left.equalTo(selectedDetentLabel.snp.right).offset(8)
            make.centerY.equalTo(selectedDetentLabel)
            make.right.equalToSuperview().inset(16)
        }
    }

    private func setupContentHeightTitleLabel() {
        scrollView.addSubview(contentHeightTitleLabel)

        contentHeightTitleLabel.text = "Preferred content height:"
        contentHeightTitleLabel.textColor = Colors.title
        contentHeightTitleLabel.font = .boldSystemFont(ofSize: 16.0)

        contentHeightTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        contentHeightTitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        contentHeightTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
        }
    }

    private func updateContentHeightValueLabel() {
        contentHeightValueLabel.text = "\(Int(contentHeightStepper.value))"
    }

    private func setupContentHeightValueLabel() {
        scrollView.addSubview(contentHeightValueLabel)

        contentHeightValueLabel.textColor = Colors.title
        contentHeightValueLabel.font = .systemFont(ofSize: 16.0)

        contentHeightValueLabel.snp.makeConstraints { make in
            make.left.equalTo(contentHeightTitleLabel.snp.right).offset(8)
            make.centerY.equalTo(contentHeightTitleLabel)
        }
    }

    private func setupContentHeightStepper() {
        scrollView.addSubview(contentHeightStepper)

        contentHeightStepper.maximumValue = 1000
        contentHeightStepper.minimumValue = 200
        contentHeightStepper.stepValue = 100
        contentHeightStepper.value = 300.0

        contentHeightStepper.addTarget(
            self,
            action: #selector(onContentHeightStepperValueChanged),
            for: .valueChanged
        )

        contentHeightStepper.snp.makeConstraints { make in
            make.top.equalTo(selectedDetentSegmentedControl.snp.bottom).offset(20)
            make.left.equalTo(contentHeightValueLabel.snp.right).offset(16)
            make.centerY.equalTo(contentHeightValueLabel)
            make.right.equalToSuperview().inset(16)
        }
    }

    private func setupScrollingExpandsHeightLabel() {
        scrollView.addSubview(scrollingExpandsHeightLabel)

        scrollingExpandsHeightLabel.text = "Scrolling expands height:"
        scrollingExpandsHeightLabel.textColor = Colors.title
        scrollingExpandsHeightLabel.font = .boldSystemFont(ofSize: 16.0)

        scrollingExpandsHeightLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
        }
    }

    private func updateScrollingExpandsHeightSwitch() {
        scrollingExpandsHeightSwitch.isOn = bottomSheet?.prefersScrollingExpandsHeight ?? false
    }

    private func setupScrollingExpandsHeightSwitch() {
        scrollView.addSubview(scrollingExpandsHeightSwitch)

        scrollingExpandsHeightSwitch.onTintColor = Colors.important

        scrollingExpandsHeightSwitch.addTarget(
            self,
            action: #selector(onScrollingExpandsHeightSwitchValueChanged),
            for: .valueChanged
        )

        scrollingExpandsHeightSwitch.snp.makeConstraints { make in
            make.top.equalTo(contentHeightStepper.snp.bottom).offset(20)
            make.left.equalTo(scrollingExpandsHeightLabel.snp.right).offset(8)
            make.centerY.equalTo(scrollingExpandsHeightLabel)
            make.right.equalToSuperview().inset(16)
        }
    }

    private func setupCanDismissLabel() {
        scrollView.addSubview(canDismissLabel)

        canDismissLabel.text = "Can dismiss:"
        canDismissLabel.textColor = Colors.title
        canDismissLabel.font = .boldSystemFont(ofSize: 16.0)

        canDismissLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
        }
    }

    private func setupCanDismissSwitch() {
        scrollView.addSubview(canDismissSwitch)

        canDismissSwitch.isOn = true
        canDismissSwitch.onTintColor = Colors.important

        canDismissSwitch.snp.makeConstraints { make in
            make.top.equalTo(scrollingExpandsHeightSwitch.snp.bottom).offset(20)
            make.left.equalTo(canDismissLabel.snp.right).offset(8)
            make.centerY.equalTo(canDismissLabel)
            make.right.bottom.equalToSuperview().inset(16)
        }
    }

    private func setupActionsView() {
        view.addSubview(actionsView)

        actionsView.backgroundColor = Colors.background

        actionsView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
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
            make.top.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
    }

    private func updatePreferredContentSize() {
        let preferredContentSize = CGSize(
            width: view.bounds.width,
            height: contentHeightStepper.value
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

        setupSelectedDetentLabel()
        setupSelectedDetentSegmentedControl()

        setupContentHeightTitleLabel()
        setupContentHeightValueLabel()
        setupContentHeightStepper()

        setupScrollingExpandsHeightLabel()
        setupScrollingExpandsHeightSwitch()

        setupCanDismissLabel()
        setupCanDismissSwitch()

        setupActionsView()
        setupCloseButton()

        updateSelectedDetentSegmentedControl()
        updateContentHeightValueLabel()
        updateScrollingExpandsHeightSwitch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        bottomSheet?.didChangeSelectedDetentKey = { [weak self] _ in
            self?.updateSelectedDetentSegmentedControl()
        }

        bottomSheet?.shouldDismiss = { [weak self] in
            self?.canDismissSwitch.isOn ?? true
        }

        updatePreferredContentSize()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updatePreferredContentSize()
    }
}
