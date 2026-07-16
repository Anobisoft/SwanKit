//
//  UIActivityIndicatorView+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UIActivityIndicatorView {

    /// Configures the color of the activity indicator wheel and returns self to enable method chaining.
    @discardableResult
    func color(_ color: UIColor!) -> Self {
        self.color = color
        return self
    }

    /// Sets the geometric size style profile of the activity indicator and returns self to enable method chaining.
    @discardableResult
    func style(_ style: UIActivityIndicatorView.Style) -> Self {
        self.style = style
        return self
    }

    /// Controls whether the receiver automatically hides when its animation is stopped and returns self to enable method chaining.
    @discardableResult
    func hidesWhenStopped(_ hides: Bool) -> Self {
        self.hidesWhenStopped = hides
        return self
    }
}
