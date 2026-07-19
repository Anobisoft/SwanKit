//
//  UIView+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UIView {

    // MARK: - Layer Geometric Configurations

    /// Sets the corner radius for the view's underlying layer background and returns self to enable method chaining.
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        return self
    }

    /// Sets the border width for the view's underlying layer and returns self to enable method chaining.
    @discardableResult
    func borderWidth(_ width: CGFloat) -> Self {
        self.layer.borderWidth = width
        return self
    }

    /// Sets the border color for the view's underlying layer and returns self to enable method chaining.
    @discardableResult
    func borderColor(_ color: UIColor?) -> Self {
        self.layer.borderColor = color?.cgColor
        return self
    }

    // MARK: - Core View Visuals

    /// Configures the background color of the view instance and returns self to enable method chaining.
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }

    /// Configures the global alpha opacity level context and returns self to enable method chaining.
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }

    /// Sets the tint color applied to the view hierarchy blueprint and returns self to enable method chaining.
    @discardableResult
    func tintColor(_ color: UIColor?) -> Self {
        self.tintColor = color
        return self
    }

    // MARK: - Hierarchy & Rendering Controls

    /// Toggles the view's visibility state context and returns self to enable method chaining.
    @discardableResult
    func isHidden(_ hidden: Bool) -> Self {
        self.isHidden = hidden
        return self
    }

    /// Determines whether subviews are confined to the bounds of the view and returns self to enable method chaining.
    @discardableResult
    func clipsToBounds(_ clips: Bool) -> Self {
        self.clipsToBounds = clips
        return self
    }

    /// Configures how the view lays out its content when its bounds change and returns self to enable method chaining.
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        self.contentMode = mode
        return self
    }

    // MARK: - Interaction & Layout Behavior

    /// Toggles whether user interaction events are delivered to the view and returns self to enable method chaining.
    @discardableResult
    func isUserInteractionEnabled(_ enabled: Bool) -> Self {
        self.isUserInteractionEnabled = enabled
        return self
    }

    /// Sets the semantic content attribute for layout direction and returns self to enable method chaining.
    @discardableResult
    func semanticContentAttribute(_ attribute: UISemanticContentAttribute) -> Self {
        self.semanticContentAttribute = attribute
        return self
    }

    /// Sets the dynamic content padding layout metrics for the view hierarchy boundaries and returns self.
    @discardableResult
    func contentInsets(_ insets: UIEdgeInsets) -> Self {
        self.contentInsets = insets
        return self
    }

}
