//
//  Keychain.SecClass.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2020-08-04.
//  Copyright © 2020 Anobisoft. All rights reserved.
//

import Foundation

extension Keychain {
    enum SecClass {
        case internetPassword
        case genericPassword
        case certificate
        case key
        case identity
        
        var rawValue: CFString {
            switch self {
            case .internetPassword:
                return kSecClassInternetPassword
            case .genericPassword:
                return kSecClassGenericPassword
            case .certificate:
                return kSecClassCertificate
            case .key:
                return kSecClassKey
            case .identity:
                return kSecClassIdentity
            }
        }
    }
}
