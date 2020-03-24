//
//  View+autolayout.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2020-03-12.
//  Copyright © 2020 Anobisoft. All rights reserved.
//

import UIKit

public extension UIView {
    static func autolayout() -> Self {
        let view = Self()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

public extension Array where Element == NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
}
