//
//  Bundle.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2020-03-23.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

import Foundation

public extension Bundle {
    static var appExecutable: String {
        main.executable^||
    }

    static var appName: String {
        main.name^||
    }

    static var appDisplayName: String {
        main.displayName^||
    }

    static var appVersion: String {
        main.shortVersion^||
    }

    static var appBuild: String {
        main.buildNumber^||
    }

    var executable: String? {
        infoDictionary?[kCFBundleExecutableKey as String] as? String
    }

    var name: String? {
        infoDictionary?[kCFBundleNameKey as String] as? String
    }

    var displayName: String? {
        infoDictionary?["CFBundleDisplayName"] as? String ?? name
    }

    var shortVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildNumber: String? {
        infoDictionary?[kCFBundleVersionKey as String] as? String
    }

    var localizableStrings: [String: String]? {
        guard let fileURL = url(forResource: "Localizable", withExtension: "strings") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let plist = try PropertyListSerialization.propertyList(from: data, format: .none)
            return plist as? [String: String]
        } catch {
            print(error)
        }
        return nil
    }
}
