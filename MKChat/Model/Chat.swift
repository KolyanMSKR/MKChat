//
//  Chat.swift
//  MKChat
//
//  Created by Admin on 24.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Chat {
    
    var senderID: String
    var senderUsername: String
    var senderAvatarStringURL: String
    var lastMessage: String
    
    var representation: [String: Any] {
        let rep: [String: Any] = ["senderID": senderID,
                   "senderUsername": senderUsername,
                   "senderAvatarStringURL": senderAvatarStringURL,
                   "lastMessage": lastMessage]
        
        return rep
    }
    
    init(senderID: String, senderUsername: String, senderAvatarStringURL: String, lastMessage: String) {
        self.senderID = senderID
        self.senderUsername = senderUsername
        self.senderAvatarStringURL = senderAvatarStringURL
        self.lastMessage = lastMessage
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let senderID = data["senderID"] as? String,
            let senderUsername = data["senderUsername"] as? String,
            let senderAvatarStringURL = data["senderAvatarStringURL"] as? String,
            let lastMessage = data["lastMessage"] as? String else {
                return nil
        }
        
        self.senderID = senderID
        self.senderUsername = senderUsername
        self.senderAvatarStringURL = senderAvatarStringURL
        self.lastMessage = lastMessage
    }
    
}
