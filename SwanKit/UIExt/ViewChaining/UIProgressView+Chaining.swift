//
//  UIProgressView+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UIProgressView {

    /// Configures the color shown for the portion of the progress bar that is filled and returns self.
    @discardableResult
    func progressTintColor(_ color: UIColor?) -> Self {
        self.progressTintColor = color
        return self
    }

    /// Configures the color shown for the portion of the progress bar that is not filled and returns self.
    @discardableResult
    func trackTintColor(_ color: UIColor?) -> Self {
        self.trackTintColor = color
        return self
    }
}
