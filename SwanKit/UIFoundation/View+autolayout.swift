
import UIKit

public extension UIView {
    static func autolayout() -> Self {
        let view = Self()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

public extension Array where Element == NSLayoutConstraint {
    @MainActor func activate() {
        NSLayoutConstraint.activate(self)
    }
}
