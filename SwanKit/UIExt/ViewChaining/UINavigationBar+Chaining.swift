//
//  UINavigationBar+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UINavigationBar {

    /// Identifies specific systemic appearance layout slots available inside a navigation bar.
    enum BarAppearanceState {
        case standard
        case compact
        case scrollEdge
    }

    // MARK: - Appearance Builder Chains

    /// Configures the standard appearance layer via a functional builder block and returns self to enable method chaining.
    @discardableResult
    func standardAppearance(_ configure: @MainActor (UINavigationBarAppearance) -> Void) -> Self {
        configure(standardAppearance)
        return self
    }

    /// Configures the scroll edge appearance layer via a functional builder block and returns self to enable method chaining.
    @discardableResult
    func scrollEdgeAppearance(_ configure: @MainActor (UINavigationBarAppearance) -> Void) -> Self {
        let scrollEdgeAppearance = scrollEdgeAppearance ?? standardAppearance.copy()
        configure(scrollEdgeAppearance)
        self.scrollEdgeAppearance = scrollEdgeAppearance
        return self
    }

    /// Configures the compact appearance layer via a functional builder block and returns self to enable method chaining.
    @discardableResult
    func compactAppearance(_ configure: @MainActor (UINavigationBarAppearance) -> Void) -> Self {
        let compactAppearance = compactAppearance ?? standardAppearance.copy()
        configure(compactAppearance)
        self.compactAppearance = compactAppearance
        return self
    }

    // MARK: - Deep Copy Navigation Chains

    /// Safely duplicates the configuration blueprint from any active layout state slot onto the standard state and returns self.
    @discardableResult
    func standardAppearance(copy source: BarAppearanceState) -> Self {
        switch source {
        case .compact:
            if let compactAppearance {
                standardAppearance = compactAppearance.copy()
            }
        case .scrollEdge:
            if let scrollEdgeAppearance {
                standardAppearance = scrollEdgeAppearance.copy()
            }
        default:
            break
        }
        return self
    }

    /// Safely duplicates the configuration blueprint from any active layout state slot onto the compact state and returns self.
    @discardableResult
    func compactAppearance(copy source: BarAppearanceState) -> Self {
        switch source {
        case .standard:
            compactAppearance = standardAppearance.copy()
        case .scrollEdge:
            if let scrollEdgeAppearance {
                compactAppearance = scrollEdgeAppearance.copy()
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
            scrollEdgeAppearance = standardAppearance.copy()
        case .compact:
            if let compactAppearance {
                scrollEdgeAppearance = compactAppearance.copy()
            }
        default:
            break
        }
        return self
    }

    // MARK: - Native Core Properties Chains

    /// Configures the background bar tint color configuration and returns self to enable method chaining.
    @discardableResult
    func barTintColor(_ color: UIColor?) -> Self {
        barTintColor = color
        return self
    }
}
