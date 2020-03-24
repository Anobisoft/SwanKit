//
//  MapTable.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2019-11-29.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public final class MapTable<KeyType: AnyObject, ObjectType: AnyObject> {

    public static func strongToStrongObjects() -> MapTable<KeyType, ObjectType> {
        self.init(mapTable: NSMapTable<KeyType, ObjectType>.strongToStrongObjects())
    }
    
    public static func weakToStrongObjects() -> MapTable<KeyType, ObjectType> {
        self.init(mapTable: NSMapTable<KeyType, ObjectType>.weakToStrongObjects())
    }
    
    public static func strongToWeakObjects() -> MapTable<KeyType, ObjectType> {
        self.init(mapTable: NSMapTable<KeyType, ObjectType>.strongToWeakObjects())
    }
    
    public static func weakToWeakObjects() -> MapTable<KeyType, ObjectType> {
        self.init(mapTable: NSMapTable<KeyType, ObjectType>.weakToWeakObjects())
    }
    
    public subscript(key: KeyType) -> ObjectType? {
        get {
            return mapTable.object(forKey: key)
        }
        set {
            if let newValue = newValue {
                mapTable.setObject(newValue, forKey: key)
            }
            else {
                mapTable.removeObject(forKey: key)
            }
        }
    }
    
    public func clear() {
        mapTable.removeAllObjects()
    }
    
    //MARK: - Private
    
    private let mapTable: NSMapTable<KeyType, ObjectType>
    
    private init(mapTable: NSMapTable<KeyType, ObjectType>) {
        self.mapTable = mapTable
    }
}
