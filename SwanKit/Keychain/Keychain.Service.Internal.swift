//
//  Keychain.Service.Internal.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2020-08-04.
//  Copyright © 2020 Anobisoft. All rights reserved.
//

import Foundation

extension Keychain.Service {
    
    func mapAccount(data: Keychain.QueryData) throws -> String {
        guard
            let account: String = data[kSecAttrAccount]
            else { throw Keychain.Error.genericPasswordParsingError }
        return account
    }
    
    func mapPasswordItem(data: Keychain.QueryData) throws -> Keychain.GenericPassword {
        guard
            let account: String = data[kSecAttrAccount],
            let passwordData: Data = data[kSecValueData],
            let password = String(data: passwordData, encoding: .utf8)
            else { throw Keychain.Error.genericPasswordParsingError }
        return try .init(service: self, account: account, password: password)
    }
    
    func fetchData<T>(includingData: Bool, map: (Keychain.QueryData) throws -> T) throws -> [T] {
        var query = makeQuery()
        query[kSecMatchLimit] = kSecMatchLimitAll
        query[kSecReturnAttributes] = true
        query[kSecReturnData] = includingData
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query.CF, &queryResult)
        guard status != errSecItemNotFound else { return [] }
        guard status == noErr else { throw status }
        guard let result = queryResult as? [Keychain.QueryData] else { throw Keychain.Error.genericPasswordParsingError }
        return try result.map(map)
    }
    
    func _fetchPassword(account: String) throws -> String? {
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
    
    func encode(_ password: String) throws -> Data {
        guard let encoded = password.data(using: .utf8) else {
            throw Keychain.Error.passwordEncodingError
        }
        return encoded
    }
    
    func _save(account: String, password: String) throws {
        let passwordData = try encode(password)
        if let _ = try _fetchPassword(account: account) {
            try update(account: account, password: passwordData)
        } else {
            try add(account: account, password: passwordData)
        }
    }
    
    func add(account: String, password: Data) throws {
        var query = makeQuery(account: account)
        query[kSecValueData] = password
        let status = SecItemAdd(query.CF, nil)
        guard status == noErr else { throw status }
    }
    
    func _delete(account: String) throws {
        let query = makeQuery(account: account)
        let status = SecItemDelete(query.CF)
        guard status == noErr || status == errSecItemNotFound else { throw status }
    }
    
    func update(account: String, password: Data) throws {
        let attributesToUpdate = [kSecValueData: password]
        let query = makeQuery(account: account)
        let status = SecItemUpdate(query.CF, attributesToUpdate.CF)
        guard status == noErr else { throw status }
    }
    
    func rename(account: String, to newName: String) throws {
        let attributesToUpdate = [kSecAttrAccount: newName]
        let query = makeQuery(account: account)
        let status = SecItemUpdate(query.CF, attributesToUpdate.CF)
        guard status == noErr || status == errSecItemNotFound else { throw status }
    }
    
    private func makeQuery(account: String? = nil, secClass: Keychain.SecClass = .genericPassword) -> Keychain.QueryData {
        var query = Keychain.QueryData()
        query.setSecClass(secClass)
        query[kSecAttrAccessGroup] = accessGroup
        query[kSecAttrService] = id
        query[kSecAttrAccount] = account
        
        return query
    }
}

