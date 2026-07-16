//
//  UIButton+Chaining.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit

@MainActor
public extension UIButton {
    /// Configures the modern button configuration layout parameters via a functional builder block and returns self.
    @discardableResult
    func configure(
        default configuration: UIButton.Configuration = .filled(),
        _ configure: (inout UIButton.Configuration) -> Void
    ) -> Self {
        var config = self.configuration ?? configuration
        configure(&config)
        self.configuration = config
        return self
    }
}
