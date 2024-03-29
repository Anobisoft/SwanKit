//
//  Alert.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2020-02-14.
//  Copyright © 2020 Anobisoft. All rights reserved.
//

import UIKit

public extension UIAlertAction {
    static let cancel: UIAlertAction = {
        .init(title: "Cancel".localized(.UIKit), style: .cancel)
    }()

    typealias Handler = (UIAlertAction) -> Void
}

public extension UIAlertController {
    func addCancel(_ handler: UIAlertAction.Handler? = nil) {
        addAction(.init(title: "Cancel".localized(.UIKit), style: .cancel, handler: handler))
    }
    
    func addAction(title: String, style: UIAlertAction.Style, handler: UIAlertAction.Handler? = nil) {
        addAction(.init(title: title, style: style, handler: handler))
    }
    
    convenience init(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert) {
        self.init(title: title, message: message, preferredStyle: style)
    }
}
