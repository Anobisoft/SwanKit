//
//  View+autolayout.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UIView {

    /// Initializes and configures a new view instance with `translatesAutoresizingMaskIntoConstraints` set to `false`.
    ///
    /// This static factory method provides a clean, declarative shortcut when constructing programmatic layout hierarchies
    /// via standard default parameterless initializers.
    ///
    /// ### Example Usage:
    /// ```swift
    /// let containerView = UIView.autolayout()
    /// let titleLabel = UILabel.autolayout()
    /// ```
    ///
    /// - Returns: A newly allocated instance of the receiving view type configured for Auto Layout processing.
    static func autolayout() -> Self {
        let view = Self()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    /// Configures an existing pre-instantiated view instance for Auto Layout by turning off auto-resizing masks conversion.
    ///
    /// This instance modifier enables fluent cascading method chaining for components requiring specialized complex initializers
    /// (e.g., custom frames, specific collection layout structures, or custom style configurations).
    ///
    /// ### Example Usage:
    /// ```swift
    /// let collection = UICollectionView(frame: .zero, collectionViewLayout: layout).autolayout()
    ///     .backgroundColor(.clear)
    ///     .clipsToBounds(true)
    /// ```
    ///
    /// - Returns: The receiver instance self reference to support continuous declarative design chaining pipelines.
    @discardableResult
    func autolayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

public extension Array where Element == NSLayoutConstraint {

    /// Concurrently activates the collection of layout constraints globally inside the native rendering cycle.
    ///
    /// This method serves as a fluent interface wrapper around `NSLayoutConstraint.activate(_:)`.
    ///
    /// ### Example Usage:
    /// ```swift
    /// [
    ///     view.topAnchor.constraint(equalTo: superview.topAnchor),
    ///     view.leadingAnchor.constraint(equalTo: superview.leadingAnchor)
    /// ].activate()
    /// ```
    @MainActor
    func activate() {
        NSLayoutConstraint.activate(self)
    }
}
