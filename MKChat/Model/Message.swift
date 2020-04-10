//
//  Message.swift
//  MKChat
//
//  Created by asd dsa on 2/15/20.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Message: Comparable {
    
    var senderID: String
    var senderUsername: String
    var text: String
    var timestamp: Timestamp
    var id: String?
    
    var representation: [String: Any] {
        let rep: [String: Any] = ["senderID": senderID,
                   "senderUsername": senderUsername,
                   "text": text,
                   "timestamp": timestamp]
        
        return rep
    }
    
    init(user: MKChatUser, text: String) {
        self.text = text
        senderID = user.id
        senderUsername = user.username
        timestamp = Timestamp()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let senderID = data["senderID"] as? String,
            let senderUsername = data["senderUsername"] as? String,
            let text = data["text"] as? String,
            let timestamp = data["timestamp"] as? Timestamp else {
                return nil
        }
        
        self.senderID = senderID
        self.senderUsername = senderUsername
        self.text = text
        self.timestamp = timestamp
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.timestamp.seconds < rhs.timestamp.seconds
    }
    
}
