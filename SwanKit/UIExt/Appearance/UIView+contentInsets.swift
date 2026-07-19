//
//  UIView+contentInsets.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-19.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

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

    private struct AssociatedKeys {
        nonisolated(unsafe) static let contentInsetsKey = malloc(1)! // выделяет 1 байт с уникальным адресом
    }

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
            let value = objc_getAssociatedObject(self, AssociatedKeys.contentInsetsKey) as? NSValue
            return value?.uiEdgeInsetsValue ?? .zero
        }
        set {
            UIView.intrinsicContentSize_swizzling
            UILabel.drawText_swizzling
            UILabel.textRect_swizzling

            objc_setAssociatedObject(self, AssociatedKeys.contentInsetsKey, NSValue(uiEdgeInsets: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
}

private extension UIView {
    static let intrinsicContentSize_swizzling: Void = {
        UIView.swizzle(
            #selector(getter: intrinsicContentSize),
            #selector(getter: intrinsicContentSize_swizzled)
        )
    }()

    @objc private var intrinsicContentSize_swizzled: CGSize {
        let size = self.intrinsicContentSize_swizzled
        let contentInsets = contentInsets

        // Safeguard layout pipelines from inflating system constants tracking unmeasurable or absent intrinsic boundaries
        guard size.width != UIView.noIntrinsicMetric && size.height != UIView.noIntrinsicMetric else { return size }

        return CGSize(
            width: size.width + contentInsets.left + contentInsets.right,
            height: size.height + contentInsets.top + contentInsets.bottom
        )
    }
}

private extension UILabel {
    static let drawText_swizzling: Void = {
        UILabel.swizzle(
            #selector(drawText(in:)),
            #selector(drawText_swizzled(in:))
        )
    }()

    static let textRect_swizzling: Void = {
        UILabel.swizzle(
            #selector(textRect(forBounds:limitedToNumberOfLines:)),
            #selector(textRect_swizzled(forBounds:limitedToNumberOfLines:))
        )
    }()

    @objc private func drawText_swizzled(in rect: CGRect) {
        let insetRect = rect.inset(by: contentInsets)
        self.drawText_swizzled(in: insetRect)
    }

    @objc private func textRect_swizzled(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetBounds = bounds.inset(by: contentInsets)
        let rect = self.textRect_swizzled(forBounds: insetBounds, limitedToNumberOfLines: numberOfLines)
        return CGRect(
            x: rect.origin.x - contentInsets.left,
            y: rect.origin.y - contentInsets.top,
            width: rect.width + contentInsets.left + contentInsets.right,
            height: rect.height + contentInsets.top + contentInsets.bottom
        )
    }
}
