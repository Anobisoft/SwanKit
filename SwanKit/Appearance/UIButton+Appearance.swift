
import UIKit

public extension UIButton {    
    @objc dynamic var titleLabelFont: UIFont? {
        get { return self.titleLabel?.font }
        set { self.titleLabel?.font = newValue }
    }
}
