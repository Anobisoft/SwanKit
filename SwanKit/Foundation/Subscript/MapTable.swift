//
//  MapTable.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-11-29.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public final class MapTable<Key: AnyObject, Value: AnyObject> {
    public static func strongToStrongObjects() -> MapTable<Key, Value> {
        self.init(mapTable: NSMapTable<Key, Value>.strongToStrongObjects())
    }
    
    public static func weakToStrongObjects() -> MapTable<Key, Value> {
        self.init(mapTable: NSMapTable<Key, Value>.weakToStrongObjects())
    }
    
    public static func strongToWeakObjects() -> MapTable<Key, Value> {
        self.init(mapTable: NSMapTable<Key, Value>.strongToWeakObjects())
    }
    
    public static func weakToWeakObjects() -> MapTable<Key, Value> {
        self.init(mapTable: NSMapTable<Key, Value>.weakToWeakObjects())
    }
    
    public subscript(key: Key) -> Value? {
        get {
            mapTable.object(forKey: key)
        }
        set {
            if let newValue {
                mapTable.setObject(newValue, forKey: key)
            } else {
                mapTable.removeObject(forKey: key)
            }
        }
    }
    
    public func clear() {
        mapTable.removeAllObjects()
    }
    
    //MARK: - Private
    
    private let mapTable: NSMapTable<Key, Value>
    
    private init(mapTable: NSMapTable<Key, Value>) {
        self.mapTable = mapTable
    }
}
