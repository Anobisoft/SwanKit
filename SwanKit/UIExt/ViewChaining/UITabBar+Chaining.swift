//
//  UITabBar+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UITabBar {

    /// Identifies specific systemic appearance layout slots available inside a tab bar.
    enum BarAppearanceState {
        case standard
        case scrollEdge
    }

    // MARK: - Appearance Builder Chains

    /// Configures the standard appearance layer via a functional builder block and returns self to enable method chaining.
    @discardableResult
    func standardAppearance(_ configure: @MainActor (UITabBarAppearance) -> Void) -> Self {
        configure(self.standardAppearance)
        return self
    }

    /// Configures the scroll edge appearance layer via a functional builder block and returns self to enable method chaining.
    @discardableResult
    func scrollEdgeAppearance(_ configure: @MainActor (UITabBarAppearance) -> Void) -> Self {
        let scrollEdgeAppearance = scrollEdgeAppearance ?? standardAppearance.copy()
        configure(scrollEdgeAppearance)
        self.scrollEdgeAppearance = scrollEdgeAppearance
        return self
    }

    // MARK: - Deep Copy Navigation Chains (Матрица «любой в любой» для таб-бара)

    /// Safely duplicates the configuration blueprint from any active layout state slot onto the standard state and returns self.
    @discardableResult
    func standardAppearance(copy source: BarAppearanceState) -> Self {
        switch source {
        case .scrollEdge:
            if let scrollEdgeAppearance {
                standardAppearance = scrollEdgeAppearance.copy()
            }
        default:
            break
        }
        return self
    }

    /// Safely duplicates the configuration blueprint from any active layout state slot onto the scroll edge state and returns self.
    @discardableResult
    func scrollEdgeAppearance(copy source: BarAppearanceState) -> Self {
        switch source {
        case .standard:
            self.scrollEdgeAppearance = self.standardAppearance.copy()
        default:
            break
        }
        return self
    }

    // MARK: - Native Core Properties Chains

    /// Configures the unselected item tint color configuration and returns self to enable method chaining.
    @discardableResult
    func unselectedItemTintColor(_ color: UIColor?) -> Self {
        self.unselectedItemTintColor = color
        return self
    }

    /// Configures the background bar tint color configuration and returns self to enable method chaining.
    @discardableResult
    func barTintColor(_ color: UIColor?) -> Self {
        self.barTintColor = color
        return self
    }
}
