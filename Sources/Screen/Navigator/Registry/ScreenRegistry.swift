import Foundation

public protocol ScreenRegistry {

    func registerObserver(
        _ observer: AnyObject,
        for target: ScreenObserverTarget
    )

    func registerObserver<T: Screen>(
        _ observer: T.Observer,
        for screen: T
    ) where T.Observer: AnyObject

    func unregisterObserver(_ observer: AnyObject)

    func unregisterObserver(
        _ observer: AnyObject,
        for target: ScreenObserverTarget
    )

    func unregisterObserver<T: Screen>(
        _ observer: T.Observer,
        for screen: T
    ) where T.Observer: AnyObject

    func observer<Observer>(
        of type: Observer.Type,
        for target: ScreenObserverTarget
    ) -> ScreenObserver<Observer>

    func observer<T: Screen>(for screen: T) -> ScreenObserver<T.Observer>
}
