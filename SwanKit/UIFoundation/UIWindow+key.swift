
import UIKit

public extension UIWindowScene {
    static var active: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }

    var keyWindow: UIWindow? {
        windows.first { $0.isKeyWindow }
    }
}
