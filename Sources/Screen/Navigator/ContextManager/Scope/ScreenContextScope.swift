import Foundation

internal protocol ScreenContextScope {

    func makeStorage(for context: AnyObject) -> ScreenContextStorage
}
