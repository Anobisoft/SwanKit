//
//  Keychain.GenericPassword.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import Foundation

extension Keychain {

    /// An active domain-specific model wrapper encapsulating a unique secure credential entry.
    ///
    /// `GenericPassword` provides a clean interface to introspect and rotate encrypted passwords
    /// or account identifiers asynchronously, ensuring all persistence mutations are dispatched
    /// safely to the underlying ``Keychain/Service`` container.
    public struct GenericPassword {

        /// The originating secure service execution domain provider bound to this record context.
        public let service: Service

        /// The unique credentials account name identifier.
        public var account: String {
            _account
        }

        /// The encrypted plain-text password string value sequence.
        public var password: String? {
            _password
        }

        /// Initializes a hydrated generic password entity configuration context asynchronously.
        ///
        /// If a local `password` string is provided, it instantly bypasses the low-level database lookup pipeline.
        /// Otherwise, it performs an upfront asynchronous lookup query to extract the archived secret payload.
        ///
        /// - Parameters:
        ///   - service: The parent secure service execution domain provider context.
        ///   - account: The unique identifier account string token matching the database target boundary.
        ///   - password: An optional pre-fetched plain-text password string value to seed the instance state.
        /// - Throws: An error if the system database lookup query encounters an unexpected operational failure.
        public init(service: Service, account: String, password: String? = nil) async throws {
            self.service = service
            _account = account

            if let password {
                _password = password
            } else {
                _password = try await service.fetchPassword(account: account)
            }
        }

        /// Mutates the active account identifier record name token asynchronously.
        ///
        /// Invoking this method initiates an underlying atomic item renaming loop transaction.
        ///
        /// - Parameter account: The new target replacement account name string identifier.
        /// - Throws: An operational system exception if the item mutation transaction is blocked by sandbox permission rules.
        public mutating func change(account: String) async throws {
            try await _set(account: account)
        }

        /// Mutates the encrypted plain-text password string value sequence asynchronously.
        ///
        /// Passing an empty or `nil` password value automatically triggers the complete deletion of the record container.
        ///
        /// - Parameter password: The brand new replacement plain-text password value sequence.
        /// - Throws: An operation write error code if the atomic underlying update transaction fails.
        public mutating func change(password: String) async throws {
            try await _set(password: password)
        }

        private var _account: String
        private var _password: String?
    }
}

// MARK: - Private Asynchronous Mutators Layer

private extension Keychain.GenericPassword {

    mutating func _set(account: String) async throws {
        try await service.rename(account: _account, to: account)
        _account = account
    }

    mutating func _set(password: String?) async throws {
        if let password = password {
            try await service.save(account: _account, password: password)
        } else {
            try await service.delete(account: _account)
        }
        _password = password
    }
}
