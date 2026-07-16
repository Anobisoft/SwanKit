//
//  KeychainServicesTests.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2026-07-17.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import Testing
import Foundation
import Security
@testable import SwanKitFoundation

@Suite("Keychain Pure Logic Specifications Suite")
struct KeychainServicesTests {

    // MARK: - 1. Query Dictionary Blueprint Generation Tests

    @Test("Keychain: Verify that makeQuery maps attributes properly into the CFDictionary architecture")
    func testQueryGenerationMapping() {
        let serviceId = "io.swankit.auth.service"
        let accessGroup = "A1B2C3D4E5.shared.group"
        let accountName = "developer_test_account"

        let service = Keychain.Service(id: serviceId, accessGroup: accessGroup)

        // Act: Generate the base query mapping blueprint without calling Apple Security APIs
        let query = service.makeQuery(account: accountName, secClass: .genericPassword)

        let extractedService: String? = query[kSecAttrService]
        let extractedGroup: String? = query[kSecAttrAccessGroup]
        let extractedAccount: String? = query[kSecAttrAccount]
        let extractedClass: String? = query[kSecClass]

        // Assert: Verify our custom subscript extracted correct raw values matching standard keys
        #expect(extractedService == serviceId)
        #expect(extractedGroup == accessGroup)
        #expect(extractedAccount == accountName)
        #expect(extractedClass as CFString? == kSecClassGenericPassword)
    }

    // MARK: - 2. Metadata Dictionary Parsing Tests

    @Test("Keychain: Verify mapAccount extracts identifier strings and throws on missing attributes")
    func testAccountMappingLogic() throws {
        let service = Keychain.Service(id: "io.swankit.stub")
        let targetAccount = "standalone_user_node"

        // Scenario A: Valid payload dictionary containing correct account identifier
        var validPayload = Keychain.QueryData()
        validPayload[kSecAttrAccount] = targetAccount as AnyObject

        let extractedAccount = try service.mapAccount(data: validPayload)
        #expect(extractedAccount == targetAccount)

        // Scenario B: Corrupted payload dictionary missing the required key
        let corruptedPayload = Keychain.QueryData()

        #expect(throws: Keychain.Error.genericPasswordParsingError) {
            try service.mapAccount(data: corruptedPayload)
        }
    }

    // MARK: - 3. Plaintext Encoding Safety Tests

    @Test("Keychain: Verify internal string serialization encoding pipeline transforms into UTF8 bytes")
    func testPasswordEncodingPipeline() throws {
        let service = Keychain.Service(id: "io.swankit.stub")
        let secretString = "volatile_framework_secret_token_123"

        // Act
        let encodedData = try service.encode(secretString)

        // Assert
        #expect(encodedData.count > 0)
        #expect(String(data: encodedData, encoding: .utf8) == secretString)
    }
}
