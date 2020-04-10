//
//  FirestoreService.swift
//  MKChat
//
//  Created by Admin on 15.03.2020.
//  Copyright © 2020 asd dsa. All rights reserved.
//

import Firebase
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    var currentUser: MKChatUser!
    
    private init() {}
    
    func getUserData(user: User, completion: @escaping (Result<MKChatUser, Error>) -> Void) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let chatUser = MKChatUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMKChatUser))
                    return
                }
                self.currentUser = chatUser
                completion(.success(chatUser))
            } else {
                completion(.failure(UserError.cannonGetUserInfo))
            }
        }
    }
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MKChatUser, Error>) -> Void) {
        
        guard Validator.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        var chatUser = MKChatUser(username: username!,
                                email: email,
                                avatarStringURL: "Not Exist",
                                description: description!,
                                sex: sex!,
                                id: id)
        
        StorageService.shared.upload(photo: avatarImage!) { result in
            switch result {
            case .success(let url):
                chatUser.avatarStringURL = url.absoluteString
                
                self.usersRef.document(chatUser.id).setData(chatUser.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(chatUser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createChat(message: String, receiver: MKChatUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let chatRef = db.collection("users/\(receiver.id)/chats")
        let messageRef = chatRef.document(currentUser.id).collection("messages")
        
        let message = Message(user: currentUser, text: message)
        
        let chat = Chat(senderID: currentUser.id,
                        senderUsername: currentUser.username,
                        senderAvatarStringURL: currentUser.avatarStringURL,
                        lastMessage: message.text,
                        timestamp: message.timestamp)
        
        chatRef.document(currentUser!.id).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            messageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(Void()))
            }
        }
        
    }
    
}
