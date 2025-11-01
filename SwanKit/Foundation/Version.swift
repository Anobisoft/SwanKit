
import Foundation

public struct Version : Sendable{
    public var major: UInt
    public var minor: UInt?
    public var patch: UInt?
    public var build: UInt?

    public init(string: String, build: String? = nil) {
        let comps = string.components(separatedBy: ".")
        var major: UInt = 0
        for (index, value) in comps.enumerated() {
            switch index {
            case 0:
                major = UInt(value) ?? 0
            case 1:
                minor = UInt(value)
            case 2:
                patch = UInt(value)
            case 4:
                self.build = UInt(value)
            default:
                break
            }
        }
        self.major = major
        if let build {
            self.build = UInt(build)
        }
    }

    public func string(with format: String = "%MJ[.MN][.P][ build B]") -> String {
        VersionFormatter(format: format).string(from: self)
    }

    public static let application = Self(string: Bundle.appVersion, build: Bundle.appBuild)
}

// MARK: - Version.Style

public class VersionFormatter {
    public enum Style: String {
        case short = "%MJ[.MN][.P][.B]"
        case medium = "v%MJ.%MN[.P][b%B]"
        case long = "v%MJ.%MN.%P build %B"
        case full = "version %MJ.%MN.%P build %B"
    }

    private let format: String

    public init(style: Style) {
        format = style.rawValue
    }

    public init(format: String = "%MJ[.MN][.P][ build B]") {
        self.format = format
    }
    
    public func string(from version: Version) -> String {
        var result = format

        result = result.replacingOccurrences(of: "%MJ", with: <!version.major)

        result = result.replacingOccurrences(of: "\\[([^%^\\[^\\]]*)MN\\]", with: <?version.minor, options: .regularExpression)
        result = result.replacingOccurrences(of: "\\[([^%^\\[^\\]]*)P\\]",  with: <?version.patch, options: .regularExpression)
        result = result.replacingOccurrences(of: "\\[([^%^\\[^\\]]*)B\\]",  with: <?version.build, options: .regularExpression)

        result = result.replacingOccurrences(of: "%MN", with: <!version.minor)
        result = result.replacingOccurrences(of: "%P", with: <!version.patch)
        result = result.replacingOccurrences(of: "%B", with: <!version.build)

        return result
    }
}

// MARK: - Private

prefix operator <?
prefix operator <!

extension Optional where Wrapped == UInt {
    static prefix func <? (value: UInt?) -> String {
        guard let value else { return "" }
        return "$1" + String(value)
    }

    static prefix func <! (value: UInt?) -> String {
        value.flatMap(String.init) ?? "0"
    }
}
