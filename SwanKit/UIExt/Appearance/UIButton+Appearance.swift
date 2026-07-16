//
//  UIButton+Appearance.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

/// A MainActor-isolated extension providing enhanced appearance styling pipelines for system buttons.
@MainActor
public extension UIButton {

    /// A dynamic, Objective-C exposed styling property allowing button font customization via the `UIAppearance` proxy framework.
    ///
    /// By default, `UIButton.titleLabel.font` cannot be modified globally via appearance proxies because it lacks the native `UI_APPEARANCE_SELECTOR` attribute.
    /// Exposing this property as `@objc dynamic` acts as a selector bridge, enabling uniform global text styling.
    ///
    /// ### Example Usage:
    /// ```swift
    /// UIButton.appearance {
    ///     \$0.titleLabelFont = UIFont.preferredFont(forTextStyle: .headline)
    /// }
    /// ```
    @objc dynamic var titleLabelFont: UIFont? {
        get { return self.titleLabel?.font }
        set { self.titleLabel?.font = newValue }
    }
}
