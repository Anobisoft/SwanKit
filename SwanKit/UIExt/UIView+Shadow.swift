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
    struct Shadow: Sendable {
        public let radius: Float
        public let colorProvider: DynamicColorProvider
        public let opacity: Float
        public let offset: CGSize

        /// Instantiates a crisp, responsive shadow design profile blueprint.
        ///
        /// - Parameters:
        ///   - radius: The geometric blur radius applied to the shadow layer filter bounds. Defaults to `10`.
        ///   - color: A dynamic closure returning a `UIColor` based on the active `UITraitCollection`.
        ///            Defaults to matching `.label` (black in light mode, white in dark mode).
        public init(
            radius: Float = 10,
            color: @escaping DynamicColorProvider = {
                $0.userInterfaceStyle == .dark ? .label : .black
            },
            opacity: Float = 1,
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
        opacity: Float = 1,
        offset: CGSize = .zero
    ) -> Self {

        self.layer.shadowRadius = CGFloat(radius)
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.masksToBounds = false

        self.layer.shadowColor = color(self.traitCollection).cgColor

        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _) in
            view.layer.shadowColor = color(view.traitCollection).cgColor
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
}
