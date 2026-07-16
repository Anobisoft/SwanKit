//
//  UIAppearance.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

public extension UIAppearance {

    /// Provides a fluent, declarative DSL closure context to customize UI appearance proxies uniformly.
    ///
    /// This method groups property configurations together, eliminating the need to repeatedly call the static appearance proxy object.
    ///
    /// ### Example Usage:
    /// ```swift
    /// UINavigationBar.appearance {
    ///     \$0.barTintColor = .systemBackground
    ///     \$0.tintColor = .label
    ///     \$0.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18)]
    /// }
    /// ```
    ///
    /// - Parameter apply: A MainActor-isolated closure execution block receiving the strongly-typed appearance proxy instance.
    @MainActor
    static func appearance(_ apply: @MainActor (Self) -> Void) {
        apply(self.appearance())
    }
}
