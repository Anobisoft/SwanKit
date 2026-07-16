//
//  UIRoundedView.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

/// A MainActor-isolated custom view that allows clip-masking specific individual corners using a customizable radiuses context.
///
/// `UIRoundedView` recalculates its underlying vector bezier path (`CAShapeLayer`) dynamically inside the core layout cycle,
/// preventing visual mask clipping bugs during interface updates, device rotations, or view resizing sequences.
///
/// ### Example Usage:
/// ```swift
/// let cardView = UIRoundedView()
/// cardView.corners = [.topLeft, .topRight] // Round only top headers
/// cardView.cornerRadius = 16.0
/// ```
@MainActor
public class UIRoundedView: UIView {

    /// The targeted collection of rectangular corners selected for rounding transformations mask constraints. Defaults to empty.
    public var corners: UIRectCorner = []

    /// The explicit radius geometric value applied to the specified rounded corners vector frames.
    public override var cornerRadius: CGFloat {
        get {
            _cornerRadius
        }
        set {
            _cornerRadius = newValue
            setNeedsLayout()
        }
    }

    // MARK: - Lifecycle Core Layout Overrides

    public override func layoutSublayers(of layer: CALayer) {
        shapeLayer.path = roundPath
        layer.mask = shapeLayer
        super.layoutSublayers(of: layer)
    }

    // MARK: - Private Technical Matrix Configurations

    private var _cornerRadius: CGFloat = 0
    private let shapeLayer = CAShapeLayer()

    private var roundPath: CGPath {
        UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        ).cgPath
    }
}
