//
//  UserError.swift
//  MKChat
//
//  Created by Admin on 15.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case cannonGetUserInfo
    case cannotUnwrapToMKChatUser
}

extension UserError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill all fields!", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Set-up a photo, please!", comment: "")
        case .cannonGetUserInfo:
            return NSLocalizedString("Cannot download user info from Firebase!", comment: "")
        case .cannotUnwrapToMKChatUser:
            return NSLocalizedString("Cannot unwrap ChatUser from User!", comment: "")
        }
    }
    
}
