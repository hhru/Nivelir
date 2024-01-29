#if canImport(UIKit)
import UIKit

internal final class BottomSheetPresentationController: UIPresentationController {

    private weak var dimmingView: BottomSheetDimmingView?
    private weak var transitionView: BottomSheetTransitionView?

    internal let transition: UIPercentDrivenInteractiveTransition
    internal let detention: BottomSheetDetentionController
    internal let interaction: BottomSheetInteractionController

    internal private(set) var state: BottomSheetPresentationState = .dismissed {
        didSet { interaction.handlePresentationState(state) }
    }

    internal var detents: [BottomSheetDetent] {
        get { detention.detents }

        set {
            detention.detents = newValue

            updateTransitionViewGrabber()
            layoutTransitionSubviews()
            updateDimmingViewRatio()
        }
    }

    internal var selectedDetentKey: BottomSheetDetentKey? {
        get { detention.selectedDetentKey }

        set {
            detention.selectedDetentKey = newValue

            updateTransitionViewGrabber()
            layoutTransitionSubviews()
            updateDimmingViewRatio()
        }
    }

    internal var preferredDimming: BottomSheetDimming = .default {
        didSet { updateDimmingView() }
    }

    internal var preferredCard: BottomSheetCard = .default {
        didSet {
            updateMaximumDetentValue()
            updateTransitionViewCard()
            layoutTransitionSubviews()
            updateDimmingViewRatio()
        }
    }

    internal var preferredGrabber: BottomSheetGrabber? {
        didSet {
            updateMaximumDetentValue()
            updateTransitionViewGrabber()
            layoutTransitionSubviews()
            updateDimmingViewRatio()
        }
    }

    internal var prefferedGrabberForMaximumDetentValue: BottomSheetGrabber? {
        didSet {
            updateMaximumDetentValue()
            updateTransitionViewGrabber()
            layoutTransitionSubviews()
            updateDimmingViewRatio()
        }
    }

    internal var prefersScrollingExpandsHeight = true {
        didSet {
            layoutTransitionSubviews()
            updateDimmingViewRatio()
        }
    }

    internal var prefersWidthFollowsPreferredContentSize = false {
        didSet {
            updateMaximumDetentValue()
            updateTransitionViewGrabber()
            layoutTransitionSubviews()
            updateDimmingViewRatio()
        }
    }

    internal var prefersEdgeAttachedInCompactHeight = false {
        didSet {
            updateTransitionView()
            layoutTransitionSubviews()
            updateDimmingViewRatio()
        }
    }

    internal var changesAnimationOptions: BottomSheetAnimationOptions = .changes {
        didSet { transition.completionCurve = changesAnimationOptions.curve }
    }

    internal var rubberBandEffect: BottomSheetRubberBandEffect? = .default

    internal var isEdgeAttached: Bool {
        prefersEdgeAttachedInCompactHeight || (traitCollection.verticalSizeClass != .compact)
    }

    internal var contentView: UIView {
        presentedViewController.view
    }

    internal override var presentedView: UIView? {
        transitionView
    }

    internal override var frameOfPresentedViewInContainerView: CGRect {
        let insets = resolveTransitionViewInsets()
        let frame = resolveTransitionViewFrame()

        return CGRect(
            x: frame.minX + insets.left,
            y: frame.minY + insets.top,
            width: frame.width - insets.horizontal,
            height: frame.height - insets.top
        )
    }

    internal override var shouldPresentInFullscreen: Bool {
        true
    }

    internal override init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?
    ) {
        transition = UIPercentDrivenInteractiveTransition()

        transition.completionCurve = changesAnimationOptions.curve
        transition.wantsInteractiveStart = false

        detention = BottomSheetDetentionController(presentedViewController: presentedViewController)
        interaction = BottomSheetInteractionController(presentedViewController: presentedViewController)

        super.init(
            presentedViewController: presentedViewController,
            presenting: presentingViewController
        )

        #if os(iOS)
        subscribeToKeyboardNotifications()
        #endif
    }

    private func resolveAdditionalInsets() -> UIEdgeInsets {
        guard let containerView, isEdgeAttached else {
            return .zero
        }

        guard traitCollection.horizontalSizeClass == .regular else {
            return .zero
        }

        let appleMagicSize = CGSize(width: 704.0, height: 995.5)
        let safeAreaInsets = containerView.safeAreaInsets

        let minInsets = max(safeAreaInsets.horizontal, safeAreaInsets.vertical)

        let preferredWidth = prefersWidthFollowsPreferredContentSize
            ? presentedViewController.preferredContentSize.width
            : appleMagicSize.width

        let horizontalInsets = 0.5 * (containerView.bounds.width - preferredWidth)

        guard horizontalInsets >= minInsets else {
            return .zero
        }

        let verticalInsets = traitCollection.horizontalSizeClass == .regular
            ? max(0.5 * (containerView.bounds.height - appleMagicSize.height), minInsets)
            : .zero

        return UIEdgeInsets(
            top: max(verticalInsets - safeAreaInsets.top, .zero),
            left: max(horizontalInsets - safeAreaInsets.left, .zero),
            bottom: verticalInsets,
            right: max(horizontalInsets - safeAreaInsets.right, .zero)
        )
    }

    private func resolveMaximumDetentValue() -> CGFloat {
        guard let containerView else {
            return .zero
        }

        let cardContentInset = preferredCard.contentInsets

        let grabberInset = -min(
            prefferedGrabberForMaximumDetentValue?.inset ?? .zero,
            preferredGrabber?.inset ?? .zero
        )

        let additionalInsets = resolveAdditionalInsets()

        let maximumDetentValue = containerView.bounds.height
            - containerView.safeAreaInsets.vertical
            - additionalInsets.vertical
            - cardContentInset.vertical
            - grabberInset

        return max(maximumDetentValue, .zero)
    }

    private func resolveDimmingViewRatio() -> CGFloat {
        let invisibleHeight = min(transitionView?.contentInsets.bottom ?? .zero, .zero)

        let visibleHeight = contentView.frame.height
            - contentView.safeAreaInsets.bottom
            + invisibleHeight

        let largestUndimmedHeight = preferredDimming
            .largestUndimmedDetentKey
            .flatMap(detention.resolveDetentValue(key:)) ?? .zero

        guard visibleHeight > largestUndimmedHeight else {
            return .zero
        }

        let smallestDimmedHeight = detents
            .lazy
            .compactMap(detention.resolveDetentValue(detent:))
            .filter { $0 > largestUndimmedHeight }
            .min()

        guard let smallestDimmedHeight else {
            return .zero
        }

        let dimmingRange = smallestDimmedHeight - largestUndimmedHeight
        let dimmingDelta = visibleHeight - largestUndimmedHeight

        return min(dimmingDelta / dimmingRange, 1.0)
    }

    private func resolveGrabber() -> BottomSheetGrabber? {
        guard isEdgeAttached else {
            return nil
        }

        let currentDetentValue = detention.resolveCurrentDetentValue()

        if currentDetentValue < detention.maximumDetentValue - .leastNonzeroMagnitude {
            return preferredGrabber
        }

        return prefferedGrabberForMaximumDetentValue
    }

    private func resolveTransitionViewFrame() -> CGRect {
        guard let containerView else {
            return .zero
        }

        let containerBounds = containerView.bounds

        if !isEdgeAttached {
            return containerBounds
        }

        let safeAreaInsets = containerView.safeAreaInsets

        return CGRect(
            x: safeAreaInsets.left,
            y: safeAreaInsets.top,
            width: containerBounds.width - safeAreaInsets.horizontal,
            height: containerBounds.height - safeAreaInsets.top
        )
    }

    private func resolveTransitionViewInsets() -> UIEdgeInsets {
        guard let transitionView, isEdgeAttached else {
            return .zero
        }

        let safeAreaInsets = transitionView.safeAreaInsets

        let cardContentInsets = transitionView.card?.contentInsets ?? .zero
        let grabberInset = -min(transitionView.grabber?.inset ?? .zero, .zero)

        let additionalInsets = resolveAdditionalInsets()

        let smallestDetentValue = detention.resolveSmallestDetentValue()
        let currentDetentValue = detention.resolveCurrentDetentValue()

        let interactionHeight = currentDetentValue + interaction.currentDetentDelta
        let transitionDelta = max(smallestDetentValue - interactionHeight, .zero)

        let topInset = transitionView.bounds.height
            - interactionHeight
            - safeAreaInsets.bottom
            - additionalInsets.bottom
            - cardContentInsets.vertical
            - grabberInset

        let bottomInset = additionalInsets.bottom - transitionDelta

        return UIEdgeInsets(
            top: topInset,
            left: additionalInsets.left,
            bottom: bottomInset,
            right: additionalInsets.right
        )
    }

    @objc private func onDimmingViewTapGesture() {
        guard state == .presented else {
            return
        }

        guard delegate?.presentationControllerShouldDismiss?(self) ?? true else {
            return
        }

        dismissPresentedViewController()
    }

    @objc private func onTransitionViewPanGesture(recognizer: UIPanGestureRecognizer) {
        guard isEdgeAttached else {
            return
        }

        interaction.handlePanGesture(
            recognizer: recognizer,
            presentationController: self
        )

        if interaction.state.isActive {
            layoutTransitionSubviews()
            updateDimmingViewRatio()
        } else {
            animateChanges {
                self.updateTransitionViewGrabber()
                self.layoutTransitionSubviews()
                self.updateDimmingViewRatio()
            }
        }
    }

    private func animateChangesAlongsideTransition(_ changes: @escaping () -> Void) {
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else {
            return animateChanges(changes)
        }

        transitionCoordinator.animate(
            alongsideTransition: { _ in
                changes()
            },
            completion: nil
        )
    }

    private func updateMaximumDetentValue() {
        detention.maximumDetentValue = resolveMaximumDetentValue()
    }

    private func updateDimmingViewRatio() {
        dimmingView?.ratio = resolveDimmingViewRatio()
    }

    private func updateDimmingView() {
        guard let dimmingView else {
            return
        }

        dimmingView.color = preferredDimming.color
        dimmingView.blurStyle = preferredDimming.blurStyle

        updateDimmingViewRatio()
    }

    private func layoutDimmingView() {
        guard let dimmingView, let containerView else {
            return
        }

        dimmingView.frame = containerView.bounds

        dimmingView.layoutIfNeeded()
    }

    private func setupDimmingView() {
        let dimmingView = BottomSheetDimmingView(
            presentingView: presentingViewController.view
        )

        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.clipsToBounds = true
        dimmingView.alpha = .zero

        let gestureRecognizer = UITapGestureRecognizer()

        gestureRecognizer.addTarget(
            self,
            action: #selector(onDimmingViewTapGesture)
        )

        containerView?.addSubview(dimmingView)
        dimmingView.addGestureRecognizer(gestureRecognizer)

        self.dimmingView = dimmingView

        updateDimmingView()
        layoutDimmingView()
    }

    private func updateTransitionViewCard() {
        transitionView?.card = isEdgeAttached ? preferredCard : nil
    }

    private func updateTransitionViewGrabber() {
        transitionView?.grabber = resolveGrabber()
    }

    private func updateTransitionView() {
        updateTransitionViewCard()
        updateTransitionViewGrabber()
    }

    private func layoutTransitionSubviews() {
        guard let transitionView else {
            return
        }

        transitionView.contentInsets = resolveTransitionViewInsets()

        transitionView.layoutIfNeeded()
    }

    private func layoutTransitionView() {
        transitionView?.frame = resolveTransitionViewFrame()

        layoutTransitionSubviews()
    }

    private func setupTransitionView() {
        let transitionView = BottomSheetTransitionView(contentView: contentView)

        transitionView.clipsToBounds = false

        let gestureRecognizer = UIPanGestureRecognizer()

        gestureRecognizer.addTarget(
            self,
            action: #selector(onTransitionViewPanGesture(recognizer:))
        )

        gestureRecognizer.delegate = interaction

        containerView?.addSubview(transitionView)
        transitionView.addGestureRecognizer(gestureRecognizer)

        self.transitionView = transitionView

        updateTransitionView()
        layoutTransitionView()
    }

    internal func invalidateDetents() {
        detention.invalidateDetents()

        updateMaximumDetentValue()
        updateTransitionViewGrabber()
        layoutTransitionSubviews()
        updateDimmingViewRatio()
    }

    internal func animateChanges(_ changes: @escaping () -> Void) {
        guard state.canAnimateChanges else {
            return changes()
        }

        let animator = UIViewPropertyAnimator(
            duration: changesAnimationOptions.duration,
            curve: changesAnimationOptions.curve,
            animations: changes
        )

        animator.startAnimation()
    }

    internal func dismissPresentedViewController() {
        delegate?.presentationControllerWillDismiss?(self)

        presentingViewController.dismiss(animated: true) {
            if self.state == .dismissed {
                self.delegate?.presentationControllerDidDismiss?(self)
            }
        }
    }

    internal override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        updateMaximumDetentValue()
        setupDimmingView()
        setupTransitionView()

        animateChangesAlongsideTransition {
            self.dimmingView?.alpha = 1.0
        }

        state = .presenting
    }

    internal override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)

        transition.wantsInteractiveStart = false

        if completed {
            state = .presented
        } else {
            dimmingView?.removeFromSuperview()
            transitionView?.removeFromSuperview()

            state = .dismissed
        }
    }

    internal override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        animateChangesAlongsideTransition {
            self.dimmingView?.alpha = .zero
        }

        state = .dismissing
    }

    internal override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)

        transition.wantsInteractiveStart = false

        if completed {
            dimmingView?.removeFromSuperview()
            transitionView?.removeFromSuperview()

            state = .dismissed
        } else {
            state = .presented
        }
    }

    internal override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()

        updateMaximumDetentValue()
        updateTransitionViewGrabber()
        layoutTransitionView()
        layoutDimmingView()
        updateDimmingViewRatio()
    }

    internal override func preferredContentSizeDidChange(
        forChildContentContainer container: UIContentContainer
    ) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)

        detention.invalidateDetents()

        animateChanges {
            self.updateTransitionViewGrabber()
            self.layoutTransitionSubviews()
            self.updateDimmingViewRatio()
        }
    }

    internal override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        detention.invalidateDetents()

        updateTransitionView()
        layoutTransitionSubviews()
        updateDimmingViewRatio()
    }
}

#if os(iOS)
extension BottomSheetPresentationController: KeyboardHandler {

    internal func handleKeyboardFrame(
        _ keyboardFrame: CGRect,
        animationDuration: TimeInterval,
        animationOptions: UIView.AnimationOptions
    ) {
        let keyboardHeight = transitionView.map { transitionView in
            transitionView
                .convert(transitionView.bounds, to: nil)
                .intersection(keyboardFrame)
                .height
        } ?? .zero

        detention.keyboardHeight = contentView.firstResponder != nil
            ? keyboardHeight
            : .zero

        if !interaction.state.isActive {
            UIView.animate(
                withDuration: animationDuration,
                delay: .zero,
                options: [animationOptions, .beginFromCurrentState]
            ) {
                self.updateTransitionViewGrabber()
                self.layoutTransitionSubviews()
                self.updateDimmingViewRatio()
            }
        }
    }
}
#endif
#endif
