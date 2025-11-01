
import Foundation

extension OSStatus: Swift.Error {}

extension Keychain {
    public enum Error: Swift.Error {
        case genericPasswordParsingError
        case passwordEncodingError
    }
}
