import Foundation

@MainActor
internal protocol ScreenObserverStorage: AnyObject {

    var predicate: ScreenObserverPredicate { get }
    var value: ScreenObserver? { get }
}
