//
//  UIView+clipsToBounds.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-19.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

/// A MainActor-isolated extension enabling global `clipsToBounds` visual configuration layers natively via the `UIAppearance` styling subsystem.
///
/// Under native iOS SDK bounds, the standard `UIView.clipsToBounds` attribute lacks the `UI_APPEARANCE_SELECTOR` macro tag,
/// meaning that declarative proxy stylesheets cannot forward clipping states onto live rendering nodes. This extension introduces
/// an Objective-C dynamically dispatched proxy attribute (`_clipsToBounds`) backed by a Just-In-Time (JIT) `layoutSubviews`
/// swizzling pipeline to seamlessly bypass this structural framework limitation.
///
/// ### Core Responsibilities:
/// - **UIAppearance Synchronization:** Captures proxy layout directives smoothly and holds them inside associated process memory locations.
/// - **Late Layout Binding:** Re-applies the targeted clipping state onto the host view instance automatically during the systemic layout resolution pass.
/// - **Zero Boot Overhead:** Lazily hooks into the runtime layout pipelines exactly once upon the initial property allocation step.
@MainActor
public extension UIView {

    private struct AssociatedKeys {
        // Concurrency-safe low-level C memory token ensuring a 100% unique key address globally.
        nonisolated(unsafe) static let clipsToBounds = malloc(1)!
    }

    // MARK: - Core Design System Token Property

    /// A dynamic, Objective-C exposed layout attribute enabling global boundary clipping adjustments via the standard UIAppearance engine proxy templates.
    ///
    /// Since the native `clipsToBounds` implementation does not inherit stylesheet forwarding tokens natively, use this explicit
    /// proxy variable inside central themes sheet definitions to control boundary constraints uniforms.
    ///
    /// ### Example Usage:
    /// ```swift
    /// StatusConsoleLabel.appearance { proxy in
    ///     proxy._clipsToBounds = true
    /// }
    /// ```
    @IBInspectable
    @objc dynamic var _clipsToBounds: Bool {
        get {
            if let value = objc_getAssociatedObject(self, AssociatedKeys.clipsToBounds) as? NSNumber {
                return value.boolValue
            }
            return false
        }
        set {
            // Just-In-Time Execution: Exchanging implementations maps lazily upon property assignment passes
            Self.layoutSubviews_clipsToBounds_swizzling
            objc_setAssociatedObject(self, AssociatedKeys.clipsToBounds, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Private Just-In-Time Layout Swizzler

private extension UIView {

    /// A thread-safe, lazily evaluated static token executing runtime method pointer exchanges exactly once upon proxy mutation.
    static let layoutSubviews_clipsToBounds_swizzling: Void = {
        UIView.swizzle(
            #selector(layoutSubviews),
            #selector(layoutSubviews_clipsToBounds_swizzled)
        )
    }()

    /// Intercepted layout signature transferring stored appearance states onto native framework parameters dynamically.
    @objc private func layoutSubviews_clipsToBounds_swizzled() {
        // 1. Pass execution control cleanly to the original layout engine implementations
        self.layoutSubviews_clipsToBounds_swizzled()

        // 2. Extract the wrapped Boolean token and apply it back onto the initialized live system variable boundary
        if let value = objc_getAssociatedObject(self, AssociatedKeys.clipsToBounds) as? NSNumber {
            clipsToBounds = value.boolValue
        }
    }
}
