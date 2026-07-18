//
//  UINavigationBarAppearance+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UINavigationBarAppearance {

    /// Sets the background color of the navigation bar appearance layout and returns self for chaining.
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }

    /// Sets the text attributes for the navigation bar's standard title and returns self for chaining.
    @discardableResult
    func titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        self.titleTextAttributes = attributes
        return self
    }

    /// Sets the text attributes for the navigation bar's large title and returns self for chaining.
    @discardableResult
    func largeTitleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        self.largeTitleTextAttributes = attributes
        return self
    }
}

