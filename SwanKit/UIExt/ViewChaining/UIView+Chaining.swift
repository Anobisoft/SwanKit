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
        self.cornerRadius = radius
        return self
    }

    /// Sets the border width for the view's underlying layer and returns self to enable method chaining.
    @discardableResult
    func borderWidth(_ width: CGFloat) -> Self {
        self.borderWidth = width
        return self
    }

    /// Sets the border color for the view's underlying layer and returns self to enable method chaining.
    @discardableResult
    func borderColor(_ color: UIColor?) -> Self {
        self.borderColor = color
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
        self._clipsToBounds = clips
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

}

// MARK: - contentInsets

public extension UIView {

    /// Sets the dynamic content padding layout metrics for the view hierarchy boundaries and returns self.
    ///
    /// - Parameter insets: The structured `UIEdgeInsets` specifying margins for all four edges.
    /// - Returns: The receiver instance self reference to enable continuous method chaining.
    @discardableResult
    func contentInsets(_ insets: UIEdgeInsets) -> Self {
        self.contentInsets = insets
        return self
    }

    /// Sets the dynamic content padding layout metrics for the view hierarchy boundaries and returns self.
    ///
    /// - Parameters:
    ///   - top: The padding distance applied onto the top boundary edge. Defaults to `0`.
    ///   - left: The padding distance applied onto the leading boundary edge. Defaults to `0`.
    ///   - bottom: The padding distance applied onto the bottom boundary edge. Defaults to `0`.
    ///   - right: The padding distance applied onto the trailing boundary edge. Defaults to `0`.
    ///   - Returns: The receiver instance self reference to support declarative layout pipelines.
    @discardableResult
    func contentInsets(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        self.contentInsets = .init(top: top, left: left, bottom: bottom, right: right)
        return self
    }

    /// Sets the dynamic content padding layout metrics for the view hierarchy boundaries and returns self.
    ///
    /// - Parameters:
    ///   - horizontal: The uniform padding distance applied onto both leading and trailing edges symmetrically. Defaults to `0`.
    ///   - vertical: The uniform padding distance applied onto both top and bottom edges symmetrically. Defaults to `0`.
    ///   - Returns: The receiver instance self reference to enable comfortable method chaining loops.
    @discardableResult
    // FEATURE FIXED: Resolved typo from 'verical' to 'vertical' to ensure perfect corporate-grade naming synchronization.
    func contentInsets(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> Self {
        self.contentInsets = .init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        return self
    }

    /// Sets the dynamic content padding layout metrics uniformly for all four view hierarchy boundaries and returns self.
    ///
    /// - Parameter all: The universal padding distance applied uniformly onto top, left, bottom, and right bounds. Defaults to `0`.
    /// - Returns: The receiver instance self reference to support fluid declarative layout vectors.
    @discardableResult
    func contentInsets(all: CGFloat = 0) -> Self {
        self.contentInsets = .init(top: all, left: all, bottom: all, right: all)
        return self
    }
}
