import Foundation

public protocol ScreenObservatory {

    func registerObserver(
        _ observer: AnyObject,
        for target: ScreenObservationTarget
    )

    func registerObserver<T: Screen>(
        _ observer: T.Observer,
        for screen: T
    ) where T.Observer: AnyObject

    func unregisterObserver(
        _ observer: AnyObject,
        for target: ScreenObservationTarget
    )

    func unregisterObserver<T: Screen>(
        _ observer: T.Observer,
        for screen: T
    ) where T.Observer: AnyObject

    func unregisterObserver(_ observer: AnyObject)

    func observation<Observer>(
        of type: Observer.Type,
        for target: ScreenObservationTarget
    ) -> ScreenObservation<Observer>

    func observation<T: Screen>(for screen: T) -> ScreenObservation<T.Observer>
}
