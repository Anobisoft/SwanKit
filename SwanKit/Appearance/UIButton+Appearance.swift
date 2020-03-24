//
//  UIButton+Appearance.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-23-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension UIButton {    
    @objc dynamic var titleLabelFont: UIFont? {
        get { return self.titleLabel?.font }
        set { self.titleLabel?.font = newValue }
    }
}
