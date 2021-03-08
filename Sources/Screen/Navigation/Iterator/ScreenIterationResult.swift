import Foundation

public enum ScreenIterationResult {

    case shouldContinue(matchingContainer: ScreenContainer?)
    case shouldStop(matchingContainer: ScreenContainer)
}
