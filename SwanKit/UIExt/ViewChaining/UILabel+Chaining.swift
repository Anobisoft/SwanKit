//
//  UILabel+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UILabel {

    /// Sets the primary plain text content string and returns self to enable method chaining.
    @discardableResult
    func text(_ text: String?) -> Self {
        self.text = text
        return self
    }

    /// Configures the primary text color and returns self to enable method chaining.
    @discardableResult
    func textColor(_ color: UIColor!) -> Self {
        self.textColor = color
        return self
    }

    /// Configures the typography font structure and returns self to enable method chaining.
    @discardableResult
    func font(_ font: UIFont!) -> Self {
        self.font = font
        return self
    }

    /// Sets the systemic layout text alignment preference and returns self to enable method chaining.
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }

    /// Sets the maximum number of lines allowed for rendering text and returns self to enable method chaining.
    @discardableResult
    func numberOfLines(_ lines: Int) -> Self {
        self.numberOfLines = lines
        return self
    }

    /// Configures the line-breaking behavior mechanics for truncating text and returns self to enable method chaining.
    @discardableResult
    func lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        self.lineBreakMode = mode
        return self
    }

    /// Toggles whether the font size should automatically shrink to fit the bounding rectangle constraints and returns self to enable method chaining.
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjusts
        return self
    }

    /// Sets the minimum scale factor for font size shrinkage when adjusting to fit width, and returns self to enable method chaining.
    @discardableResult
    func minimumScaleFactor(_ factor: CGFloat) -> Self {
        self.minimumScaleFactor = factor
        return self
    }
}
