import Foundation

/// A value that represents either a continuation or a stop iteration,
/// including the associated container value in each case.
public enum ScreenIterationResult {

    /// Continue iterating if possible, starting from `suitableContainer`.
    case shouldContinue(suitableContainer: ScreenContainer?)

    /// Stop iterating on `suitableContainer`.
    case shouldStop(suitableContainer: ScreenContainer)
}
