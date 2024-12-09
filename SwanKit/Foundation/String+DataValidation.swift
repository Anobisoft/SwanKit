//
//  String+DataValidation.swift
//  SwanKit
//
//  Created by Stanislav Pletnev on 2018-08-13.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

import Foundation

public extension String {
    var isValidEmail: Bool {
        get throws { try isValidLink(scheme: "mailto") }
    }

    func isValidLink(scheme: String? = nil) throws -> Bool {
        var check: TextCheck? = nil
        if let scheme {
            check = { $0.url?.scheme == scheme }
        }
        return try isValid(type: .link, check: check)
    }

    var isValidPhonenumber: Bool {
        get throws { try isValid(type: .phoneNumber) }
    }

    typealias TextCheck = (NSTextCheckingResult) -> Bool

    func isValid(type: NSTextCheckingResult.CheckingType, check: TextCheck? = nil) throws -> Bool {
        let detector = try NSDataDetector(types: type.rawValue)
        let range = NSRange(location: 0, length: self.count)
        var valid: Bool = false
        detector.enumerateMatches(in: self, options: .reportCompletion, range: range) { result, _, stop in
            guard let result else { return }
            valid = result.resultType.contains(type)
            valid = valid && (result.range == range)
            if let check = check {
                valid = valid && check(result)
            }
            stop.initialize(to: ObjCBool(valid))
        }
        return valid
    }
}
