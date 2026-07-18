//
//  UIImageView+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UIImageView {

    /// Sets the primary image asset and returns self to enable method chaining.
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// Sets the image asset displayed when the view is highlighted and returns self to enable method chaining.
    @discardableResult
    func highlightedImage(_ image: UIImage?) -> Self {
        self.highlightedImage = image
        return self
    }

    /// Toggles the highlighted state context of the image view and returns self to enable method chaining.
    @discardableResult
    func isHighlighted(_ highlighted: Bool) -> Self {
        self.isHighlighted = highlighted
        return self
    }

    /// Applies a specific symbol configuration profile for rendering SF Symbols and returns self to enable method chaining.
    @discardableResult
    func symbolConfiguration(_ configuration: UIImage.SymbolConfiguration?) -> Self {
        self.preferredSymbolConfiguration = configuration
        return self
    }
}
