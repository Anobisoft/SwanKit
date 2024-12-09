//
//  UIView+Appearance.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-23-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension UIView {
    @IBInspectable
    @objc dynamic var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }

    @IBInspectable
    @objc dynamic var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor }
        get {
            guard let borderColor = layer.borderColor else { return nil }
            return UIColor.init(cgColor: borderColor)
        }
    }

    @IBInspectable
    @objc dynamic var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
}
