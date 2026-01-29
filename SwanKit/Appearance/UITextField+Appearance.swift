
import UIKit

public extension UITextField {
    @objc
    func set(edgeInsets: UIEdgeInsets) {
        Self.appearanceExtensionInit
        UITextFieldProxy[self] = edgeInsets
    }

    dynamic var edgeInsets: UIEdgeInsets? {
        return UITextFieldProxy[self]
    }

    private static let appearanceExtensionInit: Void = {
        UITextField.swizzle(#selector(UITextField.textRect), #selector(UITextField.textRect_swizzled))
        UITextField.swizzle(#selector(UITextField.editingRect), #selector(UITextField.editingRect_swizzled))
    }()

    @objc
    private func textRect_swizzled(bounds: CGRect) -> CGRect {
        let rect = textRect_swizzled(bounds: bounds)
        guard let edgeInsets = edgeInsets else {
            return rect
        }
        return rect.inset(by: edgeInsets)
    }

    @objc
    private func editingRect_swizzled(bounds: CGRect) -> CGRect {
        let rect = editingRect_swizzled(bounds: bounds)
        guard let edgeInsets = edgeInsets else {
            return rect
        }
        return rect.inset(by: edgeInsets)
    }
}

@MainActor
private struct UITextFieldProxy {
    static subscript(instance: NSObject) -> UIEdgeInsets? {
        get {
            edgeInsetsMap[instance]?.edgeInsets
        }
        set {
            edgeInsetsMap[instance] = UIEdgeInsetsContainer(newValue)
        }
    }

    private class UIEdgeInsetsContainer: NSObject {
        let edgeInsets: UIEdgeInsets?
        init(_ value: UIEdgeInsets?) {
            edgeInsets = value
        }
    }

    private static let edgeInsetsMap = MapTable<NSObject, UIEdgeInsetsContainer>.weakToStrongObjects()
}
