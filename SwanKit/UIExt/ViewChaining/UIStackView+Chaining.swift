//
//  UIStackView+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-19.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UIStackView {

    /// Adds an array of views to the end of the arrangedSubviews array and returns self to enable method chaining.
    @discardableResult
    func arrangedSubviews(_ subviews: [UIView]) -> Self {
        subviews.forEach { self.addArrangedSubview($0) }
        return self
    }

    /// Sets the axis along which the arranged views are laid out and returns self to enable method chaining.
    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }

    /// Sets the spacing between adjacent views in the stack view and returns self to enable method chaining.
    @discardableResult
    func spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }

    /// Sets the distribution of the arranged views along the stack view’s axis and returns self to enable method chaining.
    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }

    /// Sets the alignment of the arranged subviews perpendicular to the stack view’s axis and returns self to enable method chaining.
    @discardableResult
    func alignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }
}
