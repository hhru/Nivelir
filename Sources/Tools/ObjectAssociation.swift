import Foundation

internal final class ObjectAssociation<T> {

    private let policy: objc_AssociationPolicy

    internal init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }

    internal subscript(object: AnyObject) -> T? {
        get {
            objc_getAssociatedObject(
                object,
                Unmanaged.passRetained(self).toOpaque()
            ) as? T
        }

        set {
            objc_setAssociatedObject(
                object,
                Unmanaged.passRetained(self).toOpaque(),
                newValue,
                policy
            )
        }
    }
}
