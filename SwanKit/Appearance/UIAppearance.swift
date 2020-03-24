//
//  UIAppearance.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-23-11.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension UIAppearance {
    static func appearance(_ apply: (Self) -> Void) {
        apply(self.appearance())
    }
}
