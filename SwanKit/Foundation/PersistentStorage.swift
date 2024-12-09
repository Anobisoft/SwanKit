//
//  PersistentStorage.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-10-25.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public protocol PersistentStorage {
    func retrieveObject<T: Decodable>(forKey key: String) throws -> T?
    func store<T: Encodable>(_ object: T, forKey key: String) throws

    func retrieveObject<T: Storagable>(forKey key: String) throws -> T?
    func store<T: Storagable>(_ object: T) throws

    func removeObject(forKey key: String)

    func data(forKey key: String) -> Data?
    func save(_ data: Data, forKey key: String) throws
}

public protocol Storagable {
    static var storage: PersistentStorage { get }

    init?(id: String, data: Data) throws

    var id: String { get }
    var data: Data { get }

    static func load(id: String) throws -> Self?
    func save() throws
    func remove()
}

extension Storagable {
    var compositeKey: String {
        Self.compositeKey(id)
    }

    static func compositeKey(_ id: String) -> String {
        let separator = "."
        var nestedParts = String(reflecting: Self.self).components(separatedBy: separator)
        nestedParts = nestedParts.filter { !$0.hasPrefix("(unknown context at $") }
        nestedParts.append(id)
        return nestedParts.joined(separator: separator)
    }
}

public extension PersistentStorage {
    func retrieveObject<T: Decodable>(forKey key: String) throws -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try data.decode()
    }

    func store<T: Encodable>(_ object: T, forKey key: String) throws {
        let data = try object.encode()
        try save(data, forKey: key)
    }

    func retrieveObject<T: Storagable>(forKey key: String) throws -> T? {
        guard let data = data(forKey: T.compositeKey(key)) else { return nil }
        return try T(id: key, data: data)
    }

    func store<T: Storagable>(_ object: T) throws {
        try save(object.data, forKey: object.compositeKey)
    }
}

extension UserDefaults: PersistentStorage {
    public func store<T: Storagable>(_ object: T) throws {
        save(object.data, forKey: object.id)
    }

    public func save(_ data: Data, forKey key: String) {
        set(data, forKey: key)
    }
}

public extension Encodable {
    func save(for id: String, to storage: PersistentStorage) throws {
        try storage.store(self, forKey: id)
    }
}

public extension Decodable {
    static func load(id: String, from storage: PersistentStorage) throws -> Self? {
        try storage.retrieveObject(forKey: id)
    }
}

public extension Storagable {
    static func load(id: String) throws -> Self? {
        try Self.storage.retrieveObject(forKey: id)
    }

    func save() throws {
        try Self.storage.store(self)
    }

    func remove() {
        Self.storage.removeObject(forKey: id)
    }
}

public extension Storagable where Self: Codable {
    init?(id: String, data: Data) throws {
        self = try Self.decode(data: data)
    }

    var data: Data {
        try! self.encode()
    }
}

public struct FileStorage: PersistentStorage {
    public static let caches = try! FileStorage()
    public static let documents = try! FileStorage(.documents)

    public enum Directory {
        case caches
        case documents
    }

    public init(_ directory: Directory = .caches, path: String = "") throws {
        let search: FileManager.SearchPathDirectory
        switch directory {
        case .documents:
            search = .documentDirectory
        default:
            search = .cachesDirectory
        }
        url = FileManager.default.urls(for: search, in: .userDomainMask).first!.appendingPathComponent(path)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }

    public func removeObject(forKey key: String) {
        do {
            try FileManager.default.removeItem(at: fileURL(key))
        } catch {
            print("\(String(describing: type(of: self))) removeObject() error: no object for key: '\(key)'")
        }
    }

    public func data(forKey key: String) -> Data? {
        return FileManager.default.contents(atPath: fileURL(key).path)
    }

    public func save(_ data: Data, forKey key: String) throws {
        try data.write(to: fileURL(key), options: .atomic)
    }


    //MARK: - Private

    private let url: URL

    private func fileURL(_ key: String) -> URL {
        return url.appendingPathComponent(key)
    }
}
