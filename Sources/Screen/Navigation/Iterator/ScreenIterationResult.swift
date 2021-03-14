import Foundation

public enum ScreenIterationResult {

    case shouldContinue(suitableContainer: ScreenContainer?)
    case shouldStop(suitableContainer: ScreenContainer)
}
