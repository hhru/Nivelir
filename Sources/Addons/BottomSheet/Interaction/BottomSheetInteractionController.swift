#if canImport(UIKit)
import UIKit

@MainActor
internal final class BottomSheetInteractionController: NSObject {

    private var interaction: BottomSheetInteraction = BottomSheetDismissedInteraction()

    private var simultaneousScrollView: UIScrollView?
    private var simultaneousScrollObservation: NSKeyValueObservation?

    internal let presentedViewController: UIViewController

    internal private(set) var state: BottomSheetInteractionState = .finished

    internal var currentDetentDelta: CGFloat {
        interaction.currentDetentDelta
    }

    internal init(presentedViewController: UIViewController) {
        self.presentedViewController = presentedViewController
    }

    private func resetSimultaneousScrollIfNeeded() {
        guard let simultaneousScrollView else {
            return
        }

        if currentDetentDelta > .leastNonzeroMagnitude {
            return simultaneousScrollView.resetVerticalScroll(finishing: true)
        }

        if currentDetentDelta < -.leastNonzeroMagnitude {
            return simultaneousScrollView.resetVerticalScroll(finishing: false)
        }

        if presentedViewController.isBeingDismissed {
            return simultaneousScrollView.resetVerticalScroll(finishing: false)
        }

        if !simultaneousScrollView.isScrolledVertically {
            return simultaneousScrollView.resetVerticalScroll(finishing: false)
        }
    }

    private func startInteraction(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer
    ) {
        state = .starting

        simultaneousScrollObservation = simultaneousScrollView?.observe(\.contentOffset) { [weak self] _, _ in
            MainActor.assumeIsolated {
                self?.resetSimultaneousScrollIfNeeded()
            }
        }

        interaction.start(
            presentationController: presentationController,
            gestureRecognizer: gestureRecognizer,
            simultaneousScrollView: simultaneousScrollView
        )

        resetSimultaneousScrollIfNeeded()
    }

    private func updateInteraction(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer
    ) {
        state = .updating

        interaction.update(
            presentationController: presentationController,
            gestureRecognizer: gestureRecognizer,
            simultaneousScrollView: simultaneousScrollView
        )

        resetSimultaneousScrollIfNeeded()
    }

    private func finishInteraction(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer
    ) {
        interaction.finish(
            presentationController: presentationController,
            gestureRecognizer: gestureRecognizer,
            simultaneousScrollView: simultaneousScrollView
        )

        resetSimultaneousScrollIfNeeded()

        simultaneousScrollView = nil
        simultaneousScrollObservation = nil

        state = .finished
    }

    private func cancelInteraction(
        presentationController: BottomSheetPresentationController,
        gestureRecognizer: UIPanGestureRecognizer
    ) {
        interaction.cancel(
            presentationController: presentationController,
            gestureRecognizer: gestureRecognizer,
            simultaneousScrollView: simultaneousScrollView
        )

        simultaneousScrollView = nil
        simultaneousScrollObservation = nil

        state = .cancelled
    }

    internal func handlePanGesture(
        recognizer: UIPanGestureRecognizer,
        presentationController: BottomSheetPresentationController
    ) {
        guard presentationController.isEdgeAttached else {
            return
        }

        switch recognizer.state {
        case .began:
            startInteraction(
                presentationController: presentationController,
                gestureRecognizer: recognizer
            )

        case .changed:
            updateInteraction(
                presentationController: presentationController,
                gestureRecognizer: recognizer
            )

        case .ended:
            finishInteraction(
                presentationController: presentationController,
                gestureRecognizer: recognizer
            )

        case .cancelled, .failed, .possible:
            cancelInteraction(
                presentationController: presentationController,
                gestureRecognizer: recognizer
            )

        @unknown default:
            cancelInteraction(
                presentationController: presentationController,
                gestureRecognizer: recognizer
            )
        }
    }

    internal func handlePresentationState(_ presentationState: BottomSheetPresentationState) {
        switch presentationState {
        case .presenting:
            interaction = BottomSheetPresentingInteraction(previousInteraction: interaction)

        case .presented:
            interaction = BottomSheetPresentedInteraction(previousInteraction: interaction)

        case .dismissing:
            interaction = BottomSheetDismissingInteraction(previousInteraction: interaction)

        case .dismissed:
            interaction = BottomSheetDismissedInteraction()
        }
    }
}

extension BottomSheetInteractionController: UIGestureRecognizerDelegate {

    internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        simultaneousScrollView = nil
        simultaneousScrollObservation = nil

        return true
    }

    internal func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        !interaction.canRecognizeGestures
    }

    internal func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        guard interaction.canRecognizeGestures else {
            return false
        }

        switch gestureRecognizer.state {
        case .cancelled, .failed, .ended:
            return false

        case .possible, .began, .changed:
            break

        @unknown default:
            return false
        }

        guard let scrollView = otherGestureRecognizer.view as? UIScrollView else {
            return otherGestureRecognizer is UITapGestureRecognizer
        }

        guard !scrollView.canScrollHorizontally else {
            return false
        }

        if simultaneousScrollView == nil {
            simultaneousScrollView = scrollView
        }

        guard !scrollView.isScrolledVertically else {
            return false
        }

        return simultaneousScrollView === scrollView
    }
}
#endif
