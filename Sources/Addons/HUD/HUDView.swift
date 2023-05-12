#if canImport(UIKit)
import UIKit

internal final class HUDView: UIView {

    #if os(iOS)
    private let progressToolbar = UIToolbar()
    #else
    private let progressToolbar = UIView()
    #endif

    private let progressView = ProgressView()

    private var animation: HUDAnimation?
    private var timer: Timer?

    private override init(frame: CGRect) {
        super.init(frame: frame)

        setupProgressToolbar()
        setupProgressView()
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupProgressToolbar() {
        addSubview(progressToolbar)

        progressToolbar.translatesAutoresizingMaskIntoConstraints = false
        progressToolbar.clipsToBounds = true
        progressToolbar.layer.masksToBounds = true

        progressToolbar.setContentHuggingPriority(.defaultLow, for: .vertical)
        progressToolbar.setContentHuggingPriority(.defaultLow, for: .horizontal)

        progressToolbar.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        progressToolbar.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let constraints = [
            progressToolbar.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressToolbar.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupProgressView() {
        progressToolbar.addSubview(progressView)

        progressView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            progressView.topAnchor.constraint(equalTo: progressToolbar.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: progressToolbar.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: progressToolbar.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: progressToolbar.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func updateProgress(hud: HUD) {
        progressView.progress = hud.progress
    }

    private func updateStyle(hud: HUD) {
        progressToolbar.layer.cornerRadius = hud.style.cornerRadius
        progressToolbar.backgroundColor = hud.style.backgroundColor
        backgroundColor = hud.style.dimmingColor

        layoutIfNeeded()
    }

    private func update(
        hud: HUD,
        animation: HUDAnimation?,
        timer: Timer?,
        completion: (() -> Void)?
    ) {
        self.animation = animation

        self.timer?.invalidate()
        self.timer = timer

        updateProgress(hud: hud)

        if let animation, window != nil {
            animation.animateUpdate(
                body: {
                    self.updateStyle(hud: hud)
                },
                of: self,
                completion: completion
            )
        } else {
            updateStyle(hud: hud)
            completion?()
        }
    }
}

extension HUDView {

    private static func showView(
        _ view: HUDView,
        in window: UIWindow,
        animation: HUDAnimation?,
        completion: (() -> Void)?
    ) {
        view.translatesAutoresizingMaskIntoConstraints = false

        window.addSubview(view)

        let constraints = [
            view.topAnchor.constraint(equalTo: window.topAnchor),
            view.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        view.layoutIfNeeded()

        if let animation {
            animation.animateAppearance(of: view, completion: completion)
        } else {
            completion?()
        }
    }

    private static func hideView(
        _ view: HUDView,
        completion: (() -> Void)?
    ) {
        view.removeFromSuperview()

        completion?()
    }

    internal static func showHUD(
        _ hud: HUD,
        in window: UIWindow,
        animation: HUDAnimation?,
        duration: TimeInterval?,
        completion: (() -> Void)?
    ) {
        let currentView = window
            .subviews
            .lazy
            .compactMap { $0 as? Self }
            .first

        let timer = duration.map { duration in
            Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
                hideHUD(in: window, completion: nil)
            }
        }

        if let view = currentView {
            return view.update(
                hud: hud,
                animation: animation,
                timer: timer,
                completion: completion
            )
        }

        let view = HUDView(frame: window.frame)

        view.update(hud: hud, animation: animation, timer: timer) {
            self.showView(
                view,
                in: window,
                animation: animation,
                completion: completion
            )
        }
    }

    internal static func showHUD(
        _ hud: HUD,
        animation: HUDAnimation?,
        duration: TimeInterval?,
        completion: (() -> Void)?
    ) {
        guard let window = UIApplication.shared.firstKeyWindow else {
            completion?()
            return
        }

        showHUD(
            hud,
            in: window,
            animation: animation,
            duration: duration,
            completion: completion
        )
    }

    internal static func hideHUD(
        in window: UIWindow,
        completion: (() -> Void)?
    ) {
        let view = window
            .subviews
            .lazy
            .compactMap { $0 as? Self }
            .first

        guard let view else {
            completion?()
            return
        }

        guard let animation = view.animation else {
            return hideView(view, completion: completion)
        }

        animation.animateDisappearance(of: view) {
            hideView(view, completion: completion)
        }
    }

    internal static func hideHUD(completion: (() -> Void)?) {
        guard let window = UIApplication.shared.firstKeyWindow else {
            completion?()
            return
        }

        hideHUD(in: window, completion: completion)
    }
}
#endif
