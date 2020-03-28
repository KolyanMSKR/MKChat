//
//  Message.swift
//  MKChat
//
//  Created by asd dsa on 2/15/20.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import Foundation

struct Message {
    
    var senderID: String
    var senderUsername: String
    var text: String
    var timestamp: Date
    var id: String?
    
    init(user: MKChatUser, text: String) {
        self.text = text
        senderID = user.id
        senderUsername = user.username
        timestamp = Date()
        id = nil
    }
    
    var representation: [String: Any] {
        let rep: [String: Any] = ["senderID": senderID,
                   "senderUsername": senderUsername,
                   "text": text,
                   "timestamp": timestamp]
        
        return rep
    }
    
}
