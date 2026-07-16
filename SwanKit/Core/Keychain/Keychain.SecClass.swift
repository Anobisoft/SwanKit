//
//  Keychain.SecClass.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import Foundation

extension Keychain {

    /// A type-safe enumeration representing core item classes managed by Apple's Security framework.
    ///
    /// Extends `RawRepresentable` to safely map expressive Swift cases onto native `CFString` security identifiers.
    enum SecClass: RawRepresentable {

        /// Represents secure credentials allocated for network resource domains and websites (`kSecClassInternetPassword`).
        case internetPassword

        /// Represents generic account/password combinations utilized across local applications or frameworks (`kSecClassGenericPassword`).
        case genericPassword

        /// Represents cryptographic security certificates deployed for identity assertion validation pipelines (`kSecClassCertificate`).
        case certificate

        /// Represents raw cryptographic keys (public, private, or symmetric) used in encryption operations (`kSecClassKey`).
        case key

        /// Represents an integrated identity object combining a certificate wrapper together with its linked private key (`kSecClassIdentity`).
        case identity

        /// Maps a low-level system `CFString` object class constant identifier into a structured type case.
        ///
        /// - Parameter rawValue: The native system `CFString` item class identifier key.
        init?(rawValue: CFString) {
            switch rawValue {
            case kSecClassInternetPassword:
                self = .internetPassword
            case kSecClassGenericPassword:
                self = .genericPassword
            case kSecClassCertificate:
                self = .certificate
            case kSecClassKey:
                self = .key
            case kSecClassIdentity:
                self = .identity
            default:
                return nil
            }
        }

        /// Returns the underlying native system `CFString` class constant required for Security query construction.
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
