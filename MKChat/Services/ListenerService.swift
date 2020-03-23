//
//  ListenerService.swift
//  MKChat
//
//  Created by Admin on 21.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    
    static let shared = ListenerService()
    
    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private var currentUserID: String {
        return Auth.auth().currentUser!.uid
    }
    
    private init() {}
    
    func usersObserve(users: [MKChatUser], completion: @escaping (Result<[MKChatUser], Error>) -> Void) -> ListenerRegistration {
        let usersListener = usersRef.addSnapshotListener { querySnapshot, error in
            var users = users
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                guard let chatUser = MKChatUser(document: diff.document) else {
                    return
                }
                
                if diff.type == .added {
                    users.append(chatUser)
                }
            }
            completion(.success(users))
        }
        
        return usersListener
    }
    
}
