
import UIKit

public extension UIAppearance {
    static func appearance(_ apply: (Self) -> Void) {
        apply(self.appearance())
    }
}
