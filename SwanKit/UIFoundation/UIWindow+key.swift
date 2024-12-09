//
//  UIWindow+key.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2020-03-12.
//  Copyright © 2020 Anobisoft. All rights reserved.
//

import UIKit

public extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13.0, tvOS 13.0, *) {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }?
                .windows.first { $0.isKeyWindow }
        } else {
            UIApplication.shared.keyWindow
        }
    }
}
