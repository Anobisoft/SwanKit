//
//  Version.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2020-03-23.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

import Foundation

public struct Version {

    public enum FormatStyle: String {
        case short = "%MJ[.MN][.P][.B]"
        case medium = "v%MJ.%MN[.P][b%B]"
        case long = "v%MJ.%MN.%P build %B"
        case full = "version %MJ.%MN.%P build %B"
    }

    public var major: String
    public var minor: String?
    public var patch: String?
    public var build: String?

    public init(string: String, build: String? = nil) {
        let comps = string.components(separatedBy: ".")
        var major = ""
        for (index, value) in comps.enumerated() {
            switch index {
            case 0:
                major = value
            case 1:
                minor = value
            case 2:
                patch = value
            case 4:
                self.build = value
            default:
                break
            }
        }
        self.major = major
        if let build = build {
            self.build = build
        }
    }

    public static let applicationVersion = Self(string: Bundle.appVersion, build: Bundle.appBuild)

    public func string(format: String = "%MJ[.MN][.P][.B]") -> String {
        var result = format
        result = result.replacingOccurrences(of: "%MJ", with: major)

        result = result.replacingOccurrences(of: "\\[([^%^\\[^\\]]*)MN\\]", with: optional(minor), options: .regularExpression)
        result = result.replacingOccurrences(of: "\\[([^%^\\[^\\]]*)P\\]",  with: optional(patch), options: .regularExpression)
        result = result.replacingOccurrences(of: "\\[([^%^\\[^\\]]*)B\\]",  with: optional(build), options: .regularExpression)

        result = result.replacingOccurrences(of: "%MN", with: required(minor))
        result = result.replacingOccurrences(of: "%P", with: required(patch))
        result = result.replacingOccurrences(of: "%B", with: required(build))
        return result
    }

    public func string(style: FormatStyle) -> String {
        string(format: style.rawValue)
    }

    private func optional(_ value: String?) -> String {
        guard let value = value else {
            return ""
        }
        return "$1" + value
    }

    private func required(_ value: String?) -> String {
        value ?? "0"
    }
}
