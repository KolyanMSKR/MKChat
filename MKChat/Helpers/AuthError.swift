//
//  AuthError.swift
//  MKChat
//
//  Created by Admin on 14.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case serverError
    case unknownError
}

extension AuthError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill all fields", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Invalid Email", comment: "")
        case .serverError:
            return NSLocalizedString("Server Error", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown Error", comment: "")
        }
    }
    
}
