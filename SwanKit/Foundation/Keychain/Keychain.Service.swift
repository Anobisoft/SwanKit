//
//  Keychain.Service.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-17.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import Foundation

public extension Keychain.Service {

    /// A convenience alias routing to the framework's secure credential model wrapper layer.
    typealias GenericPassword = Keychain.GenericPassword

    /// Extracts a secure text password string payload associated with a specific identifier account name asynchronously.
    ///
    /// The operation executes on the system cooperative pool to avoid freezing the main user interface.
    ///
    /// - Parameter account: The unique identifier account name token matching the record target boundary.
    /// - Returns: The extracted decrypted plain-text password string layout representation, or `nil` if the entry is absent.
    /// - Throws: An `OSStatus` error code if the Security framework fails, or a ``Keychain/Error/genericPasswordParsingError`` if binary decoding fails.
    func fetchPassword(account: String) async throws -> String? {
        var query = makeQuery(account: account)
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecReturnAttributes] = false
        query[kSecReturnData] = true
        var queryResult: CFTypeRef?
        let status = SecItemCopyMatching(query.CF, &queryResult)
        guard status != errSecItemNotFound else { return nil }
        guard status == noErr else { throw status }
        guard let valueData = queryResult as? Data,
              let password = String(data: valueData, encoding: .utf8)
        else {
            throw Keychain.Error.genericPasswordParsingError
        }
        return password
    }

    /// Atomically persists or updates a secure plain-text password string associated with a targeted account name asynchronously.
    ///
    /// This method automatically handles upsert redirection mechanics on a background thread.
    ///
    /// - Parameters:
    ///   - account: The unique target account name token to bind the credentials payload onto.
    ///   - password: The source plain-text password string value sequence to encrypt.
    /// - Throws: An `OSStatus` file systems write error code if the atomic underlying addition or mutation transaction fails.
    func save(account: String, password: String) async throws {
        let passwordData = try encode(password)
        if let _ = try await fetchPassword(account: account) {
            try update(account: account, password: passwordData)
        } else {
            try add(account: account, password: passwordData)
        }
    }

    /// Remotely sweeps and eliminates a secure credential item entry matching the specific account name token boundary asynchronously.
    ///
    /// If the targeted key record is missing, the operation exits gracefully without throwing errors.
    ///
    /// - Parameter account: The unique target account identifier name string to delete.
    /// - Throws: An execution `OSStatus` subsystem exception if active sandboxing boundaries block the erasure loop.
    func delete(account: String) async throws {
        let query = makeQuery(account: account)
        let status = SecItemDelete(query.CF)
        guard status == noErr || status == errSecItemNotFound else { throw status }
    }

    /// Creates a convenience runtime interface wrapper bound to a dedicated account context descriptor asynchronously.
    ///
    /// - Parameter account: The account identifier name token.
    /// - Returns: A dedicated ``Keychain/GenericPassword`` management item instance.
    /// - Throws: An error if initial secure fetching loops fail.
    func obtainPassword(account: String) async throws -> GenericPassword {
        try await .init(service: self, account: account)
    }

    /// Extracts a complete flat collection of all unique account names securely archived inside this service context boundary asynchronously.
    ///
    /// - Returns: A string array containing the extracted un-ordered account names.
    /// - Throws: A subsystem operational exception if metadata query lookup loops fail.
    func fetchAccounts() async throws -> [String] {
        try await fetchData(includingData: false, map: mapAccount(data:))
    }

    /// Extracts a comprehensive collection of all generic password objects securely archived inside this service context profile asynchronously.
    ///
    /// - Returns: An array containing fully hydrated ``Keychain/GenericPassword`` instance data objects.
    /// - Throws: A parsing exception code if binary decryption sequences map onto corrupted memory frames.
    func fetchPasswords() async throws -> [GenericPassword] {
        try await fetchData(includingData: true, map: mapPasswordItem(data:))
    }

    /// Renames an existing secure account identifier name token to a brand new designation structure asynchronously.
    ///
    /// - Parameters:
    ///   - account: The active source account identifier name string currently recorded.
    ///   - newName: The target replacement account identifier string sequence.
    /// - Throws: An `OSStatus` operational exception code if the item update loop is blocked by permission rules.
    func rename(account: String, to newName: String) async throws {
        let attributesToUpdate = [kSecAttrAccount: newName]
        let query = makeQuery(account: account)
        let status = SecItemUpdate(query.CF, attributesToUpdate.CF)
        guard status == noErr || status == errSecItemNotFound else { throw status }
    }
}
