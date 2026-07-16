//
//  UITextField+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UITextField {

    /// Sets the placeholder text configuration string and returns self to enable method chaining.
    @discardableResult
    func placeholder(_ text: String?) -> Self {
        self.placeholder = text
        return self
    }

    /// Configures the text color of the field and returns self to enable method chaining.
    @discardableResult
    func textColor(_ color: UIColor?) -> Self {
        self.textColor = color
        return self
    }

    /// Configures the typography font structure and returns self to enable method chaining.
    @discardableResult
    func font(_ font: UIFont?) -> Self {
        self.font = font
        return self
    }

    /// Sets the systemic layout text alignment preference and returns self to enable method chaining.
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }

    /// Configures the background border style layer for the field container and returns self to enable method chaining.
    @discardableResult
    func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        self.borderStyle = style
        return self
    }

    /// Configures the systemic overlay clear button rendering behavior metrics and returns self to enable method chaining.
    @discardableResult
    func clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        self.clearButtonMode = mode
        return self
    }

    // MARK: - UITextInputTraits Chaining Pipelines

    /// Configures the keyboard type variations for the text field input cycle and returns self to enable method chaining.
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Self {
        self.keyboardType = type
        return self
    }

    /// Sets the text autocorrection behavior metrics and returns self to enable method chaining.
    @discardableResult
    func autocorrectionType(_ type: UITextAutocorrectionType) -> Self {
        self.autocorrectionType = type
        return self
    }

    /// Sets the text autocapitalization behavior mechanics and returns self to enable method chaining.
    @discardableResult
    func autocapitalizationType(_ type: UITextAutocapitalizationType) -> Self {
        self.autocapitalizationType = type
        return self
    }

    /// Securely hides typing characters for sensitive input tracks (like passwords) and returns self to enable method chaining.
    @discardableResult
    func isSecureTextEntry(_ secure: Bool) -> Self {
        self.isSecureTextEntry = secure
        return self
    }

    /// Configures the look and execution behavior of the return key token and returns self to enable method chaining.
    @discardableResult
    func returnKeyType(_ type: UIReturnKeyType) -> Self {
        self.returnKeyType = type
        return self
    }

    /// Sets the dynamic text padding edge insets and returns self to enable method chaining.
    @discardableResult
    func textRectInsets(_ insets: UIEdgeInsets) -> Self {
        self.textRectInsets = insets
        return self
    }
}
