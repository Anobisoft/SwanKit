//
//  UIView+Layer.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

/// A MainActor-isolated extension injecting core border and corner radius design attributes directly into the base `UIView`.
@MainActor
public extension UIView {

    /// The radius utilized when drawing the rounded corners of the view's underlying CoreAnimation layer background.
    ///
    /// Exposing this property as `@IBInspectable` injects a visual slider controller directly into Xcode's Interface Builder storyboard palette.
    /// Combined with `@objc dynamic`, it seamlessly enables global batch modifications via the standard `UIAppearance` framework proxy routing.
    ///
    /// ### Example Usage:
    /// ```swift
    /// UIView.appearance {
    ///     \$0.cornerRadius = 8.0
    /// }
    /// ```
    @IBInspectable
    @objc dynamic var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    /// The color of the view's underlying CoreAnimation layer border layout boundary.
    ///
    /// This property wraps the low-level `CGColor` references, automating conversion metrics back and forth to standard `UIColor` wrappers.
    @IBInspectable
    @objc dynamic var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }

    /// The structural width thickness of the view's underlying CoreAnimation layer border outline strokes.
    @IBInspectable
    @objc dynamic var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
}
