//
//  UITextField+textRectInsets.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

private enum AssociatedKeys {
    static let insetsKey = "SwanKit.UITextField.textRectInsets.key"
}

/// A MainActor-isolated extension adding dynamic padding layout customizability to text fields via runtime method swizzling.
///
/// `UITextField+Appearance` intercepts and modifies the internal padding spaces applied uniformly around the active text
/// boundaries inside input forms. While base structural extensions modify external view alignments, this module targets internal typography coordinates.
///
/// ### Core Responsibilities:
/// - **Visual Formatting:** Drives customized spacing offsets separating input text vectors from the host frame borders natively.
/// - **Just-In-Time Swizzling:** Automatically hooks structural layout methods exactly once upon initial property allocation steps.
/// - **Design System Support:** Exposes dynamic Objective-C attributes to leverage native `UIAppearance` central themes styling.
@MainActor
public extension UITextField {

    // MARK: - Core Design System Token Property

    /// The dynamic layout text padding edge insets configured for the target text field instance.
    ///
    /// This property allows granular internal margin control separating input text layers from the host view framing bounds.
    /// It can be set directly on individual field instances or configured globally using the `UIAppearance` proxy infrastructure.
    ///
    /// ### Example Usage:
    /// ```swift
    /// UITextField.appearance { proxy in
    ///     proxy.textRectInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    /// }
    /// ```
    @objc dynamic var textRectInsets: UIEdgeInsets {
        get {
            let value = objc_getAssociatedObject(self, AssociatedKeys.insetsKey) as? NSValue
            return value?.uiEdgeInsetsValue ?? .zero
        }
        set {
            Self.extensionInit
            objc_setAssociatedObject(self, AssociatedKeys.insetsKey, NSValue(uiEdgeInsets: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsLayout()
        }
    }

    // MARK: - Runtime Swizzling Core Orchestration

    /// A thread-safe, static token executing runtime method pointer exchanges exactly once upon property assignment.
    private static let extensionInit: Void = {
        UITextField.swizzle(
            #selector(UITextField.textRect),
            #selector(UITextField.textRect_swizzled)
        )
        UITextField.swizzle(
            #selector(UITextField.editingRect),
            #selector(UITextField.editingRect_swizzled)
        )
    }()

    /// Intercepted layout signature mutating text bounds properties dynamically based on active insets.
    @objc
    private func textRect_swizzled(bounds: CGRect) -> CGRect {
        let rect = textRect_swizzled(bounds: bounds)
        return rect.inset(by: textRectInsets)
    }

    /// Intercepted layout signature mutating active typing session bounds dynamically based on active insets.
    @objc
    private func editingRect_swizzled(bounds: CGRect) -> CGRect {
        let rect = editingRect_swizzled(bounds: bounds)
        return rect.inset(by: textRectInsets)
    }
}
