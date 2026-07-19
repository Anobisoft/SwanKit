//
//  UIView+contentInsets.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-19.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

private enum AssociatedKeys {
    static let insetsKey = "SwanKit.UIView.contentInsets.key"
}

/// A MainActor-isolated extension injecting dynamic layout content padding customizability globally into the base `UIView` layer.
///
/// `UIView+contentInsets` introduces an enterprise-grade layout abstraction that seamlessly embeds custom `UIEdgeInsets`
/// directly into the core Auto Layout constraints resolution engine. By swizzling low-level boundary methods, this extension
/// provides structural internal padding capabilities to *any* subclass out of the box (e.g., `UILabel`, `UIImageView`, custom views),
/// completely eliminating the need to construct single-use subclass components for basic margin spacing.
///
/// ### Core Responsibilities:
/// - **Unified Layout Geometry:** Seamlessly inflates alignment rectangles and dynamic metrics frames to accumulate design tokens paddings.
/// - **Just-In-Time Swizzling:** Lazily hooks systemic frame-binding properties exactly once upon the initial property allocation sequence.
/// - **Central Styling Control:** Fully supports native `UIAppearance` proxy workflows for global, declarative interface theme orchestration.
public extension UIView {

    // MARK: - Core Design System Token Property

    /// The dynamic layout content padding metrics injected globally into the base UIView layer.
    ///
    /// This property dictates how much internal padding space the engine should enforce around the view's active content boundaries.
    /// It modifies both the constraint alignment layout borders and the intrinsic content frames recursively.
    ///
    /// This metric can be assigned to unique object instances at runtime or broadcasted globally via the `UIAppearance` style proxy framework.
    ///
    /// ### Example Usage:
    /// ```swift
    /// UILabel.appearance { proxy in
    ///     proxy.contentInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
    /// }
    /// ```
    @objc dynamic var contentInsets: UIEdgeInsets {
        get {
            let value = objc_getAssociatedObject(self, AssociatedKeys.insetsKey) as? NSValue
            return value?.uiEdgeInsetsValue ?? .zero
        }
        set {
            Self.extensionInit

            objc_setAssociatedObject(self, AssociatedKeys.insetsKey, NSValue(uiEdgeInsets: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }

    // MARK: - Lazy Private Swizzling Trigger Anchor

    /// A thread-safe, lazily evaluated static token executing the Objective-C runtime method pointer exchanges exactly once upon assignment.
    private static let extensionInit: Void = {
        UIView.swizzle(
            #selector(getter: alignmentRectInsets),
            #selector(swan_alignmentRectInsets)
        )
        UIView.swizzle(
            #selector(getter: intrinsicContentSize),
            #selector(swan_intrinsicContentSize)
        )
    }()

    // MARK: - Swizzled Implementations

    /// Intercepted layout bounds signature accumulating design token insets into native alignment frame margins.
    @objc func swan_alignmentRectInsets() -> UIEdgeInsets {
        let originalInsets = self.swan_alignmentRectInsets()
        return UIEdgeInsets(
            top: originalInsets.top + contentInsets.top,
            left: originalInsets.left + contentInsets.left,
            bottom: originalInsets.bottom + contentInsets.bottom,
            right: originalInsets.right + contentInsets.right
        )
    }

    /// Intercepted geometry signature inflating intrinsic bounds dimensions to dynamically accommodate stylesheet padding allocations.
    @objc func swan_intrinsicContentSize() -> CGSize {
        let size = self.swan_intrinsicContentSize()
        let contentInsets = contentInsets

        // Safeguard layout pipelines from inflating system constants tracking unmeasurable or absent intrinsic boundaries
        guard size.width != UIView.noIntrinsicMetric && size.height != UIView.noIntrinsicMetric else { return size }

        return CGSize(
            width: size.width + contentInsets.left + contentInsets.right,
            height: size.height + contentInsets.top + contentInsets.bottom
        )
    }
}
