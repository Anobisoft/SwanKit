//
//  Keychain.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2020-08-04.
//  Copyright © 2020 Anobisoft. All rights reserved.
//

import Foundation

public struct Keychain {

    public struct Service {
        public let accessGroup: String?
        public let id: String

        public init(accessGroup: String? = nil, id: String) {
            self.accessGroup = accessGroup
            self.id = id
        }

        public func fetchPassword(account: String) throws -> String? {
            try _fetchPassword(account: account)
        }

        public func save(account: String, password: String) throws {
            try _save(account: account, password: password)
        }

        public func delete(account: String) throws {
            try _delete(account: account)
        }

        public func obtainPassword(account: String) throws -> GenericPassword {
            try .init(service: self, account: account)
        }

        public func fetchAccounts() throws -> [String] {
            try fetchData(includingData: false, map: mapAccount(data:))
        }

        public func fetchPasswords() throws -> [GenericPassword] {
            try fetchData(includingData: true, map: mapPasswordItem(data:))
        }
    }
}

