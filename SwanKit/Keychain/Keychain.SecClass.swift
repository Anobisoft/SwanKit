
import Foundation

extension Keychain {
    enum SecClass: RawRepresentable {
        case internetPassword
        case genericPassword
        case certificate
        case key
        case identity

        init?(rawValue: CFString) {
            switch rawValue {
            case kSecClassInternetPassword:
                self = .internetPassword
            case kSecClassGenericPassword:
                self = .genericPassword
            case kSecClassCertificate:
                self = .certificate
            case kSecClassKey:
                self = .key
            case kSecClassIdentity:
                self = .identity
            default:
                return nil
            }
        }

        var rawValue: CFString {
            switch self {
            case .internetPassword:
                return kSecClassInternetPassword
            case .genericPassword:
                return kSecClassGenericPassword
            case .certificate:
                return kSecClassCertificate
            case .key:
                return kSecClassKey
            case .identity:
                return kSecClassIdentity
            }
        }
    }
}
