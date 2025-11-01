
import Foundation

extension Keychain {
    public struct GenericPassword {
        public let service: Service

        public var account: String {
            get { _account }
            set { try? _set(account: newValue) }
        }

        public var password: String? {
            get { _password }
            set { try? _set(password: newValue) }
        }

        init(service: Service, account: String, password: String? = nil) throws {
            self.service = service
            _account = account
            _password = try password ?? service.fetchPassword(account: account)
        }

        public mutating func change(account: String) throws {
            try _set(account: account)
        }

        public mutating func change(password: String) throws {
            try _set(password: password)
        }

        private var _account: String
        private var _password: String?
    }
}

private extension Keychain.GenericPassword {
    mutating func _set(account: String) throws {
        try service.rename(account: _account, to: account)
        _account = account
    }

    mutating func _set(password: String?) throws {
        if let password = password {
            try service.save(account: _account, password: password)
        } else {
            try service.delete(account: _account)
        }
        _password = password
    }
}
