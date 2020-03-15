//
//  Validator.swift
//  MKChat
//
//  Created by Admin on 14.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import UIKit

class Validator {
    
    static func isFilled(email: String?, password: String?) -> Bool {
        guard let email = email,
            let password = password,
            email != "",
            password != "" else {
                return true
        }
        
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return predicate.evaluate(with: text)
    }
    
}
