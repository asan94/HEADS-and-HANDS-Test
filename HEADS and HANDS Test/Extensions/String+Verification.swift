//
//  String+Verification.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 29.06.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

import Foundation

extension String {


    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    func isEmpty() -> Bool {
        return (self == "")
    }
    var length: Int {
        return self.characters.count
    }
    func isPassword() -> Bool {
        let pas = "((?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{6,20})"
         return NSPredicate(format: "SELF MATCHES %@", pas).evaluate(with: self)
    }
}
