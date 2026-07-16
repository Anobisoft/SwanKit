//
//  Keychain.Service.Internal.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-17.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import Foundation
import Security

extension Keychain.Service {

    /// Maps a raw dictionary payload block extracted from the Security framework metadata into a clean account identifier string.
    ///
    /// - Parameter data: The dictionary container payload parsed from the Security query.
    /// - Returns: The un-encapsulated flat string account name identifier token.
    /// - Throws: A ``Keychain/Error/genericPasswordParsingError`` if the required account key attributes are missing.
    func mapAccount(data: Keychain.QueryData) throws -> String {
        guard
            let account: String = data[kSecAttrAccount]
        else { throw Keychain.Error.genericPasswordParsingError }
        return account
    }

    /// Maps a raw dictionary payload block into a hydrated ``Keychain/GenericPassword`` active data object wrapper asynchronously.
    ///
    /// - Parameter data: The dynamic dictionary container payload including raw binary password buffers.
    /// - Returns: A fully initialized, active ``Keychain/GenericPassword`` instance structure.
    /// - Throws: A ``Keychain/Error/genericPasswordParsingError`` if required account identifiers or value bytes fail text translation loops.
    func mapPasswordItem(data: Keychain.QueryData) async throws -> Keychain.GenericPassword {
        guard
            let account: String = data[kSecAttrAccount],
            let passwordData: Data = data[kSecValueData],
            let password = String(data: passwordData, encoding: .utf8)
        else { throw Keychain.Error.genericPasswordParsingError }
        return try await .init(service: self, account: account, password: password)
    }

    /// Performs low-level batch item data extractions from the Security sub-system using custom mapped transformations asynchronously.
    ///
    /// - Parameters:
    ///   - includingData: Pass `true` to immediately requests raw password secret payload buffers; pass `false` for attribute metadata searches only.
    ///   - map: An asynchronous parsing closure strategy to map intercepted array nodes onto targeted types.
    /// - Returns: An un-ordered collection containing successfully transformed data nodes.
    /// - Throws: An `OSStatus` error code if the low-level query breaks, or parsing exceptions if data formats are corrupted.
    func fetchData<T>(includingData: Bool, map: (Keychain.QueryData) async throws -> T) async throws -> [T] {
        var query = makeQuery()
        query[kSecMatchLimit] = kSecMatchLimitAll
        query[kSecReturnAttributes] = true
        query[kSecReturnData] = includingData
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query.CF, &queryResult)
        guard status != errSecItemNotFound else { return [] }
        guard status == noErr else { throw status }
        guard let result = queryResult as? [Keychain.QueryData] else { throw Keychain.Error.genericPasswordParsingError }

        var mappedResults: [T] = []
        for item in result {
            try await mappedResults.append(map(item))
        }
        return mappedResults
    }

    /// Converts a raw string password value sequence into encrypted-ready byte data blocks.
    ///
    /// - Parameter password: The plain text source string value.
    /// - Returns: A raw binary `Data` container representation.
    /// - Throws: A ``Keychain/Error/passwordEncodingError`` if the string layout sequence fails UTF-8 transformation metrics.
    func encode(_ password: String) throws -> Data {
        guard let encoded = password.data(using: .utf8) else {
            throw Keychain.Error.passwordEncodingError
        }
        return encoded
    }

    /// Appends a brand new secure credential node entry directly into the system database.
    ///
    /// - Parameters:
    ///   - account: The unique string account name token descriptor.
    ///   - password: The encrypted binary password bytes payload container.
    /// - Throws: A system `OSStatus` failure exception if active sandbox constraints restrict the insertion loop transaction.
    func add(account: String, password: Data) throws {
        var query = makeQuery(account: account)
        query[kSecValueData] = password
        let status = SecItemAdd(query.CF, nil)
        guard status == noErr else { throw status }
    }

    /// Mutates existing secure password payload attribute blocks associated with a specific key.
    ///
    /// - Parameters:
    ///   - account: The unique target string account name token descriptor recorded in the store.
    ///   - password: The replacement encrypted binary password bytes payload container.
    /// - Throws: A system `OSStatus` exception code if the item update loop transaction fails.
    func update(account: String, password: Data) throws {
        let attributesToUpdate = [kSecValueData: password]
        let query = makeQuery(account: account)
        let status = SecItemUpdate(query.CF, attributesToUpdate.CF)
        guard status == noErr else { throw status }
    }

    /// Builds a base query map pre-configured with the service's current context routing credentials.
    ///
    /// - Parameters:
    ///   - account: An optional specific account name identifier to strict-match against.
    ///   - secClass: The target Security item category layout description class. Defaults to `.genericPassword`.
    /// - Returns: A fully pre-filled ``Keychain/QueryData`` dictionary blueprint ready for system execution calls.
    func makeQuery(account: String? = nil, secClass: Keychain.SecClass = .genericPassword) -> Keychain.QueryData {
        var query = Keychain.QueryData()
        query.setSecClass(secClass)
        query[kSecAttrAccessGroup] = accessGroup
        query[kSecAttrService] = id
        query[kSecAttrAccount] = account

        return query
    }
}
