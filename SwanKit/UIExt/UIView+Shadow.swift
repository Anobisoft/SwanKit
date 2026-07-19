//
//  UIView+Shadow.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@available(iOS 17.0, tvOS 17.0, *)
@MainActor
public extension UIView {

    /// A MainActor-isolated provider closure that returns a responsive `UIColor` adjusted for the given trait environment context.
    typealias DynamicColorProvider = @MainActor (UITraitCollection) -> UIColor

    /// A data model container encapsulation grouping configuration metrics for drawing custom responsive layer shadows.
    ///
    /// This structure holds the configuration parameters needed to define a shadow layout profile blueprint, including
    /// blur metrics, opacity levels, offsets, and a closure that dynamically provides color adaptation based on the active traits.
    struct Shadow: Sendable {

        /// The geometric blur radius applied to the shadow layer filter bounds.
        public let radius: Float

        /// A dynamic closure returning a `UIColor` based on the active `UITraitCollection`.
        public let colorProvider: DynamicColorProvider

        /// The layer alpha opacity level context.
        public let opacity: Float

        /// The linear position displacement vector.
        public let offset: CGSize

        /// Instantiates a crisp, responsive shadow design profile blueprint.
        ///
        /// - Parameters:
        ///   - radius: The geometric blur radius applied to the shadow layer filter bounds. Defaults to `10`.
        ///   - color: A dynamic closure returning a `UIColor` based on the active `UITraitCollection`.
        ///            Defaults to matching `.label` (black in light mode, white in dark mode).
        ///   - opacity: The layer alpha opacity level context. Defaults to `1`.
        ///   - offset: The linear position displacement vector. Defaults to `.zero`.
        public init(
            radius: Float = 10,
            color: @escaping DynamicColorProvider = {
                $0.userInterfaceStyle == .dark ? .label : .black
            },
            opacity: Float = 0.25,
            offset: CGSize = .zero
        ) {
            self.radius = radius
            self.colorProvider = color
            self.opacity = opacity
            self.offset = offset
        }
    }

    /// Configures and applies custom dynamic layer shadow graphics onto the receiver view framework.
    ///
    /// This method automatically hooks into iOS 17's trait registration pipelines, updating the core
    /// `CALayer.shadowColor` reference instantly whenever the user interface style toggles.
    ///
    /// Unlike legacy UIKit implementations, this module isolates the shadow pipeline on a dedicated underlying twin `CAShapeLayer`.
    /// This design natively bypasses the `clipsToBounds` / `masksToBounds` conflict, allowing view content elements to clip
    /// gracefully around corner curves while letting the custom shadow float freely beyond the bounds rectangle.
    ///
    /// - Parameters:
    ///   - radius: The blur filter radius. Defaults to 10.
    ///   - color: A dynamic color provider closure that adapts to trait changes.
    ///   - opacity: The layer alpha opacity level context. Defaults to 1.
    ///   - offset: The linear position displacement vector. Defaults to `.zero`.
    /// - Returns: The receiver instance self reference to enable comfortable method chaining loops.
    @discardableResult
    func shadow(
        radius: Float = 10,
        color: @escaping DynamicColorProvider = { $0.userInterfaceStyle == .dark ? .label : .black },
        opacity: Float = 0.25,
        offset: CGSize = .zero
    ) -> Self {

        Self.layoutSubviews_shadowLayout_swizzling
        Self.removeFromSuperview_shadowLayout_swizzling

        let shadowLayer = shadowLayer
        shadowLayer.shadowRadius = CGFloat(radius)
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowOffset = offset
        shadowLayer.masksToBounds = false

        shadowLayer.shadowColor = color(self.traitCollection).cgColor

        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _) in
            shadowLayer.shadowColor = color(view.traitCollection).cgColor
        }

        return self
    }

    /// Configures and applies a pre-defined dynamic ``Shadow`` model structure profile onto the receiver view framework.
    ///
    /// - Parameter shadow: The structured container model detailing responsive parameters mapping properties.
    /// - Returns: The receiver instance self reference to support method chaining layout pipelines.
    @discardableResult
    func shadow(_ shadow: Shadow) -> Self {
        self.shadow(
            radius: shadow.radius,
            color: shadow.colorProvider,
            opacity: shadow.opacity,
            offset: shadow.offset
        )
    }

    var shadowLayer: CAShapeLayer { getShadowLayer() }
}

// MARK: - Private Twin CoreAnimation Interceptor Extension

@available(iOS 17.0, tvOS 17.0, *)
private extension UIView {
    struct AssociatedKeys {
        nonisolated(unsafe) static let shadowLayerRuntimeKey = malloc(1)!
    }

    func getShadowLayer() -> CAShapeLayer {
        if let sLayer = objc_getAssociatedObject(self, AssociatedKeys.shadowLayerRuntimeKey) as? CAShapeLayer {
            return sLayer
        }
        let sLayer = CAShapeLayer()
        objc_setAssociatedObject(self, AssociatedKeys.shadowLayerRuntimeKey, sLayer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return sLayer
    }

    static let layoutSubviews_shadowLayout_swizzling: Void = {
        UIView.swizzle(
            #selector(layoutSubviews),
            #selector(layoutSubviews_shadowLayout_swizzled)
        )
    }()

    static let removeFromSuperview_shadowLayout_swizzling: Void = {
        UIView.swizzle(
            #selector(removeFromSuperview),
            #selector(removeFromSuperview_shadowLayout_swizzled)
        )
    }()

    @objc func layoutSubviews_shadowLayout_swizzled() {
        self.layoutSubviews_shadowLayout_swizzled()

        if let sLayer = objc_getAssociatedObject(self, AssociatedKeys.shadowLayerRuntimeKey) as? CAShapeLayer {
            if sLayer.superlayer == nil {
                layer.superlayer?.insertSublayer(sLayer, below: layer)
            }
            sLayer.frame = frame
            let cornerRadius = layer.cornerRadius
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            sLayer.shadowPath = path.cgPath
        }
    }

    @objc func removeFromSuperview_shadowLayout_swizzled() {
        if let sLayer = objc_getAssociatedObject(self, AssociatedKeys.shadowLayerRuntimeKey) as? CAShapeLayer {
            sLayer.removeFromSuperlayer()
            objc_setAssociatedObject(self, AssociatedKeys.shadowLayerRuntimeKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        self.removeFromSuperview_shadowLayout_swizzled()
    }
}
