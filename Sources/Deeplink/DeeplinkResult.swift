import Foundation

internal enum DeeplinkResult {

    case success(DeeplinkStorage)
    case failure(Error)
    case warning(Error)
}
