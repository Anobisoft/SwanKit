//
//  UIKitBundle.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-12-03.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import UIKit

public extension Bundle {
    static var UIKit: Bundle {
        Self(for: UIApplication.self)
    }
}
