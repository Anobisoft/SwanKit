
import Foundation

public extension NSObject {    
    static func swizzle(_ origin: Selector, _ swizzl: Selector) {
        guard
            let origin_method = class_getInstanceMethod(self, origin),
            let swizzl_method = class_getInstanceMethod(self, swizzl)
        else { return }
        method_exchangeImplementations(origin_method, swizzl_method)
    }
}
