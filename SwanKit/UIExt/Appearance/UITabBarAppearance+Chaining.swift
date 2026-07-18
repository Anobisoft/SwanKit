//
//  UITabBarAppearance+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UITabBarAppearance {

    /// Sets the solid background color of the tab bar appearance layout and returns self for chaining.
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }

    /// Customizes typography and design layouts globally for standard portrait tab items, returning self for chaining.
    @discardableResult
    func inlineItemAppearance(_ configure: @MainActor (UITabBarItemAppearance) -> Void) -> Self {
        configure(self.inlineLayoutAppearance)
        return self
    }

    /// Customizes typography and design layouts globally for horizontal compact tab items, returning self for chaining.
    @discardableResult
    func compactInlineItemAppearance(_ configure: @MainActor (UITabBarItemAppearance) -> Void) -> Self {
        configure(self.compactInlineLayoutAppearance)
        return self
    }

    /// Safely duplicates the entire portrait items design configuration onto the landscape compact slot, returning self.
    ///
    /// This serves as an explicit, controlled pipeline to ensure style consistency when the device toggles orientations.
    @discardableResult
    func copyToCompact() -> Self {
        self.compactInlineLayoutAppearance = self.inlineLayoutAppearance.copy()
        return self
    }
}
