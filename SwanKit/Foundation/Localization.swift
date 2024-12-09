//
//  Localization.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-11-12.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public extension String {
    func localized(_ bundle: Bundle = .main, value: String? = nil, table: String? = nil) -> String {
        bundle.localized(self, value: value, table: table)
    }

    var localized: String {
        localized()
    }
}

extension Bundle {
    func localized(_ key: String, value: String? = nil, table: String? = nil) -> String {
        localizedString(forKey: key, value: value, table: table)
    }
}
