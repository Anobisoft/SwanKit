//
//  UITextField+Appearance.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKitFoundation

/// A MainActor-isolated extension adding dynamic edge insets layout customizability to text fields via method swizzling.
@MainActor
public extension UITextField {

    /// Sets text padding edge insets dynamically for the receiver text field instance.
    ///
    /// Invoking this method triggers a one-time runtime method swizzling cycle, replacing native rectangle calculations.
    ///
    /// - Parameter edgeInsets: The targeted padding configuration values block.
    @objc
    func set(edgeInsets: UIEdgeInsets) {
        Self.appearanceExtensionInit
        UITextFieldProxy[self] = edgeInsets
    }

    /// A dynamic, Objective-C exposed layout property allowing global text field padding configuration via the `UIAppearance` proxy framework.
    ///
    /// ### Example Usage:
    /// ```swift
    /// UITextField.appearance {
    ///     \$0.edgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    /// }
    /// ```
    @objc dynamic var edgeInsets: UIEdgeInsets {
        get { UITextFieldProxy[self] ?? .zero }
        set { set(edgeInsets: newValue) }
    }

    // MARK: - Runtime Swizzling Core Orchestration

    private static let appearanceExtensionInit: Void = {
        // Exchange native implementation pointers safely via runtime selectors
        UITextField.swizzle(#selector(UITextField.textRect(forBounds:)), #selector(UITextField.textRect_swizzled(bounds:)))
        UITextField.swizzle(#selector(UITextField.editingRect(forBounds:)), #selector(UITextField.editingRect_swizzled(bounds:)))
    }()

    @objc
    private func textRect_swizzled(bounds: CGRect) -> CGRect {
        let rect = textRect_swizzled(bounds: bounds)
        guard let edgeInsets = UITextFieldProxy[self] else {
            return rect
        }
        return rect.inset(by: edgeInsets)
    }

    @objc
    private func editingRect_swizzled(bounds: CGRect) -> CGRect {
        let rect = editingRect_swizzled(bounds: bounds)
        guard let edgeInsets = UITextFieldProxy[self] else {
            return rect
        }
        return rect.inset(by: edgeInsets)
    }
}

// MARK: - Thread-Safe Weak Memory Storage Registry Proxy

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

    // Utilizes SwanKit's native MapTable to eliminate reference cycles automatically
    private static let edgeInsetsMap = MapTable<NSObject, UIEdgeInsetsContainer>.weakToStrongObjects()
}
