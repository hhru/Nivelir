import Foundation

public protocol SnackBarContent: SnackBarContentView, Equatable {

    associatedtype View: SnackBarContentView where View.Content == Self

    func updateContentView(_ contentView: View, container: ScreenContainer) -> View
}
