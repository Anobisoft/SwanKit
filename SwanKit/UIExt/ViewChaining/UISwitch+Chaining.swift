//
//  UISwitch+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UISwitch {

    /// Configures the tint color used to tint the appearance of the switch when it is turned on and returns self to enable method chaining.
    @discardableResult
    func onTintColor(_ color: UIColor?) -> Self {
        self.onTintColor = color
        return self
    }

    /// Configures the tint color used to tint the appearance of the switch thumb and returns self to enable method chaining.
    @discardableResult
    func thumbTintColor(_ color: UIColor?) -> Self {
        self.thumbTintColor = color
        return self
    }

    /// Sets the state of the switch (on or off) optionally animated, and returns self to enable method chaining.
    @discardableResult
    func set(on: Bool, animated: Bool = false) -> Self {
        self.setOn(on, animated: animated)
        return self
    }
}
